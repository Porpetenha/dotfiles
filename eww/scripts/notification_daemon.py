#!/usr/bin/env python
import gi
gi.require_version("Gtk", "3.0")
gi.require_version("GdkPixbuf", "2.0")
from gi.repository import Gtk, GLib, GdkPixbuf
from pydbus import SessionBus
import subprocess
import json
import os
import time
import tempfile

# --- Configurações ---
MAX_NOTIFICATIONS = 10
DEFAULT_TIMEOUT = 10000 # 10 segundos

notifications = []
id_counter = 1

class NotificationServer:
    """
    <node>
        <interface name='org.freedesktop.Notifications'>
            <method name='Notify'>
                <arg type='s' name='app_name' direction='in'/>
                <arg type='u' name='replaces_id' direction='in'/>
                <arg type='s' name='app_icon' direction='in'/>
                <arg type='s' name='summary' direction='in'/>
                <arg type='s' name='body' direction='in'/>
                <arg type='as' name='actions' direction='in'/>
                <arg type='a{sv}' name='hints' direction='in'/>
                <arg type='i' name='expire_timeout' direction='in'/>
                <arg type='u' name='id' direction='out'/>
            </method>
            <method name='GetServerInformation'>
                <arg type='s' name='name' direction='out'/>
                <arg type='s' name='vendor' direction='out'/>
                <arg type='s' name='version' direction='out'/>
                <arg type='s' name='spec_version' direction='out'/>
            </method>
            <method name='CloseNotification'>
                <arg type='u' name='id' direction='in'/>
            </method>
             <method name='GetCapabilities'>
                <arg type='as' name='caps' direction='out'/>
            </method>
        </interface>
    </node>
    """
    
    def __init__(self):
        self.icon_theme = Gtk.IconTheme.get_default()
        self.home_dir = os.path.expanduser("~")

    def save_pixbuf(self, pixbuf, nid):
        """Salva o Pixbuf em um arquivo temporário para o Eww ler"""
        try:
            temp_path = os.path.join(tempfile.gettempdir(), f"eww_notif_{nid}.png")
            pixbuf.savev(temp_path, "png", [], [])
            return temp_path
        except Exception as e:
            print(f"Erro ao salvar imagem temporária: {e}")
            return ""

    def process_image_data(self, data, nid):
        """Converte dados brutos (raw bytes) da notificação em arquivo"""
        try:
            # Estrutura do D-Bus image-data:
            # [width, height, rowstride, has_alpha, bits_per_sample, channels, data]
            width, height, rowstride, has_alpha, bits_per_sample, channels, img_data = data
            
            # img_data vem como array de bytes, precisamos converter
            img_bytes = bytes(img_data)
            
            pixbuf = GdkPixbuf.Pixbuf.new_from_data(
                img_bytes,
                GdkPixbuf.Colorspace.RGB,
                has_alpha,
                bits_per_sample,
                width,
                height,
                rowstride
            )
            return self.save_pixbuf(pixbuf, nid)
        except Exception as e:
            print(f"Erro ao processar image-data: {e}")
            return ""

    def get_icon_path(self, icon_name, hints, nid):
        """
        Resolve o ícone com prioridade:
        1. Dados brutos (image-data) nos hints (WhatsApp, Telegram)
        2. Caminho nos hints (image-path)
        3. Caminho no argumento icon_name
        """
        
        # 1. Verifica dados brutos (O MAIS IMPORTANTE PARA WHATSAPP)
        # O spec define 'image-data' ou 'icon_data'
        img_data = hints.get("image-data") or hints.get("image_data") or hints.get("icon_data")
        if img_data:
            path = self.process_image_data(img_data, nid)
            if path: return path

        # 2. Verifica caminho nos hints
        hint_path = hints.get("image-path") or hints.get("image_path")
        if hint_path:
            resolved = self.resolve_file_path(hint_path)
            if resolved: return resolved

        # 3. Verifica argumento padrão
        if icon_name:
            resolved = self.resolve_file_path(icon_name)
            if resolved: return resolved
            
        return ""

    def resolve_file_path(self, icon_name):
        """Lógica auxiliar para resolver caminhos de string"""
        if not icon_name: return ""
        
        clean_name = icon_name.replace("file://", "")
        
        # Absoluto
        if os.path.isabs(clean_name) and os.path.exists(clean_name):
            return clean_name
            
        # Relativo à home
        path_from_home = os.path.join(self.home_dir, clean_name)
        if os.path.exists(path_from_home):
            return path_from_home
            
        # Relativo atual
        if os.path.exists(clean_name):
            return os.path.abspath(clean_name)

        # Tema do sistema
        try:
            theme_name = os.path.splitext(os.path.basename(clean_name))[0]
            icon_info = self.icon_theme.lookup_icon(theme_name, 64, 0)
            if icon_info:
                return icon_info.get_filename()
        except:
            pass
            
        return ""

    def update_eww(self):
        try:
            json_data = json.dumps(notifications)
            print(json_data, flush=True)
            subprocess.run(["eww", "update", f"notifications={json_data}"])
        except Exception as e:
            print(f"Erro ao atualizar Eww: {e}")

    def remove_notification(self, nid):
        global notifications
        # Remove arquivo temporário se existir
        temp_img = os.path.join(tempfile.gettempdir(), f"eww_notif_{nid}.png")
        if os.path.exists(temp_img):
            try:
                os.remove(temp_img)
            except:
                pass

        notifications = [n for n in notifications if n["id"] != nid]
        self.update_eww()
        return False

    def Notify(self, app_name, replaces_id, app_icon, summary, body, actions, hints, expire_timeout):
        global id_counter, notifications
        
        nid = replaces_id if replaces_id != 0 else id_counter
        if replaces_id == 0: id_counter += 1

        # Agora passamos o ID e os HINTS para resolver imagens raw
        real_icon = self.get_icon_path(app_icon, hints, nid)

        timeout = expire_timeout
        if timeout <= 0: timeout = DEFAULT_TIMEOUT

        notif = {
            "id": nid,
            "app": app_name,
            "summary": summary,
            "body": body,
            "icon": real_icon,
            "time": time.strftime("%H:%M")
        }
        
        notifications = [n for n in notifications if n["id"] != nid]
        notifications.insert(0, notif)
        notifications = notifications[:MAX_NOTIFICATIONS]
        
        self.update_eww()
        
        GLib.timeout_add(timeout, self.remove_notification, nid)
        
        return nid

    def GetServerInformation(self):
        return ("Eww Notification Server", "Custom", "1.0", "1.2")
    
    def CloseNotification(self, nid):
        self.remove_notification(nid)

    def GetCapabilities(self):
        return ["body", "icon-static"]

loop = GLib.MainLoop()
bus = SessionBus()
try:
    bus.publish("org.freedesktop.Notifications", NotificationServer())
    print("Daemon rodando! (Pressione Ctrl+C para parar)")
    subprocess.run(["eww", "update", "notifications=[]"]) 
    loop.run()
except Exception as e:
    print(f"Erro ao iniciar D-Bus: {e}")
except KeyboardInterrupt:
    pass