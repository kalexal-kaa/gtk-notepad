
using Gtk;

namespace Notepad {

    public class MainWindow : Gtk.ApplicationWindow {

private Stack stack;
private Box vbox_list_page;
private Box vbox_name_page;
private Box vbox_edit_page;
private Box vbox_view_page;
private Gtk.ListStore list_store;
private TreeView tree_view;
private GLib.List<string> list;
private TextView text_view;
private TextView view;
private Entry entry_name;
private Button back_button_view_page;
private Button back_button_edit_page;
private Button back_button_name_page;
private Button delete_button;
private Button edit_button;
private Button save_button;
private Button clear_button;
private Button add_button;
private Button view_button;
private string directory_path;
private string note_name;
private string item;
private int mode;

        public MainWindow(Gtk.Application application) {
            GLib.Object(application: application,
                         title: "Nottist",
                         window_position: WindowPosition.CENTER,
                         resizable: true,
                         height_request: 450,
                         width_request: 550,
                         border_width: 10);
        }        

        construct {        
        Gtk.HeaderBar headerbar = new Gtk.HeaderBar();
        headerbar.get_style_context().add_class(Gtk.STYLE_CLASS_FLAT);
        headerbar.show_close_button = true;
        set_titlebar(headerbar);
        back_button_view_page = new Gtk.Button ();
            back_button_view_page.set_image (new Gtk.Image.from_icon_name ("go-previous-symbolic", Gtk.IconSize.SMALL_TOOLBAR));
            back_button_view_page.vexpand = false;
        back_button_edit_page = new Gtk.Button ();
            back_button_edit_page.set_image (new Gtk.Image.from_icon_name ("go-previous-symbolic", Gtk.IconSize.SMALL_TOOLBAR));
            back_button_edit_page.vexpand = false;
        back_button_name_page = new Gtk.Button();
            back_button_name_page.set_image (new Gtk.Image.from_icon_name ("go-previous-symbolic", Gtk.IconSize.SMALL_TOOLBAR));
            back_button_name_page.vexpand = false;
        add_button = new Gtk.Button ();
            add_button.set_image (new Gtk.Image.from_icon_name ("document-new-symbolic", Gtk.IconSize.SMALL_TOOLBAR));
            add_button.vexpand = false;
        view_button = new Gtk.Button ();
            view_button.set_image (new Gtk.Image.from_icon_name ("document-open-symbolic", Gtk.IconSize.SMALL_TOOLBAR));
            view_button.vexpand = false;
        delete_button = new Gtk.Button ();
            delete_button.set_image (new Gtk.Image.from_icon_name ("edit-delete-symbolic", Gtk.IconSize.SMALL_TOOLBAR));
            delete_button.vexpand = false;
        edit_button = new Gtk.Button ();
            edit_button.set_image (new Gtk.Image.from_icon_name ("document-edit-symbolic", Gtk.IconSize.SMALL_TOOLBAR));
            edit_button.vexpand = false;
        save_button = new Gtk.Button();
            save_button.set_image (new Gtk.Image.from_icon_name ("document-save-symbolic", Gtk.IconSize.SMALL_TOOLBAR));
            save_button.vexpand = false;
        clear_button = new Gtk.Button();
            clear_button.set_image (new Gtk.Image.from_icon_name ("edit-clear-symbolic", Gtk.IconSize.SMALL_TOOLBAR));
            clear_button.vexpand = false;  
            back_button_view_page.set_tooltip_text("back");
            back_button_edit_page.set_tooltip_text("back");
            back_button_name_page.set_tooltip_text("back");
            delete_button.set_tooltip_text("delete");
            edit_button.set_tooltip_text("edit");
            save_button.set_tooltip_text("save");
            clear_button.set_tooltip_text("clear");
            view_button.set_tooltip_text("open");
            add_button.set_tooltip_text("add");
        headerbar.add(back_button_view_page);
        headerbar.add (back_button_edit_page);
        headerbar.add (back_button_name_page);
        headerbar.add(add_button);
        headerbar.add(view_button);
        headerbar.add(edit_button);
        headerbar.add(delete_button);
        headerbar.add (save_button);
        headerbar.add (clear_button);
        add_button.clicked.connect(on_add_clicked);
        delete_button.clicked.connect (on_delete_clicked);
        edit_button.clicked.connect(on_edit_clicked);
        view_button.clicked.connect(on_view_clicked);
        back_button_name_page.clicked.connect(go_to_list_page);
        back_button_edit_page.clicked.connect (go_to_name_page);
        back_button_view_page.clicked.connect(go_to_list_page);
        save_button.clicked.connect (on_save_clicked);
        clear_button.clicked.connect (on_clear_clicked);
        set_buttons_on_list_page();
          stack = new Stack();
          stack.set_transition_duration (600);
          stack.set_transition_type (StackTransitionType.SLIDE_LEFT_RIGHT);
          add (stack);
   list_store = new Gtk.ListStore(Columns.N_COLUMNS, typeof(string));
           tree_view = new TreeView.with_model(list_store);
           var text = new CellRendererText ();
           var column = new TreeViewColumn ();
           column.pack_start (text, true);
           column.add_attribute (text, "markup", Columns.TEXT);
           tree_view.append_column (column);
           tree_view.set_headers_visible (false);
           tree_view.cursor_changed.connect(on_select_item);
    var scroll_list_page = new ScrolledWindow (null, null);
        scroll_list_page.set_policy (PolicyType.AUTOMATIC, PolicyType.AUTOMATIC);
        scroll_list_page.add (this.tree_view);
   vbox_list_page = new Box(Orientation.VERTICAL,20);
   vbox_list_page.pack_start(scroll_list_page,true,true,0);
   stack.add(vbox_list_page);
        entry_name = new Entry();
        entry_name.set_icon_from_icon_name (Gtk.EntryIconPosition.SECONDARY, "edit-clear-symbolic");
        entry_name.icon_press.connect ((pos, event) => {
        if (pos == Gtk.EntryIconPosition.SECONDARY) {
            entry_name.set_text ("");
           }
        });
        var label_name = new Label.with_mnemonic ("_Name:");
        var hbox_name = new Box (Orientation.HORIZONTAL, 20);
        hbox_name.pack_start (label_name, false, true, 0);
        hbox_name.pack_start (entry_name, true, true, 0);
        var button_ok = new Button.with_label("OK");
        button_ok.clicked.connect(on_ok_clicked);
        vbox_name_page = new Box(Orientation.VERTICAL,20);
        vbox_name_page.pack_start(hbox_name,false,true,0);
        vbox_name_page.pack_start(button_ok,false,true,0);
        stack.add(vbox_name_page);
        this.text_view = new TextView ();
        this.text_view.editable = true;
        this.text_view.cursor_visible = true;
        this.text_view.set_wrap_mode (Gtk.WrapMode.WORD);
        var scroll_edit_page = new ScrolledWindow (null, null);
        scroll_edit_page.set_policy (PolicyType.AUTOMATIC, PolicyType.AUTOMATIC);
        scroll_edit_page.add (this.text_view);
        vbox_edit_page = new Box (Orientation.VERTICAL, 0);
        vbox_edit_page.pack_start (scroll_edit_page, true, true, 0);
        stack.add(vbox_edit_page);
        this.view = new TextView ();
        this.view.editable = false;
        this.view.cursor_visible = false;
        this.view.set_wrap_mode (Gtk.WrapMode.WORD);
        var scroll_view_page = new ScrolledWindow (null, null);
        scroll_view_page.set_policy (PolicyType.AUTOMATIC, PolicyType.AUTOMATIC);
        scroll_view_page.add (this.view);
        vbox_view_page = new Box(Orientation.VERTICAL,20);
        vbox_view_page.pack_start(scroll_view_page,true,true,0);
        stack.add(vbox_view_page);
        stack.visible_child = vbox_list_page;
   directory_path = Environment.get_home_dir()+"/.notes_for_notepad_app";
   GLib.File file = GLib.File.new_for_path(directory_path);
   if(!file.query_exists()){
     try{
        file.make_directory();
     }catch(Error e){
        stderr.printf ("Error: %s\n", e.message);
     }
   }
   show_notes();
}
   
   private void on_add_clicked(){
        stack.visible_child = vbox_name_page;
        set_buttons_on_name_page();
        entry_name.set_text(date_time());
        mode = 1;
   }
   
   private void on_edit_clicked(){
        var selection = tree_view.get_selection();
           selection.set_mode(SelectionMode.SINGLE);
           TreeModel model;
           TreeIter iter;
           if (!selection.get_selected(out model, out iter)) {
               alert("Choose a note");
               return;
           }
        stack.visible_child = vbox_name_page;
        set_buttons_on_name_page();
        entry_name.set_text(item);
        mode = 0;
   }
   
   private void on_delete_clicked(){
           var selection = tree_view.get_selection();
           selection.set_mode(SelectionMode.SINGLE);
           TreeModel model;
           TreeIter iter;
           if (!selection.get_selected(out model, out iter)) {
               alert("Choose a note");
               return;
           }
           GLib.File file = GLib.File.new_for_path(directory_path+"/"+item);
         var dialog_delete_file = new Gtk.MessageDialog(this, Gtk.DialogFlags.MODAL,Gtk.MessageType.QUESTION, Gtk.ButtonsType.OK_CANCEL, "Delete note "+file.get_basename()+" ?");
         dialog_delete_file.set_title("Question");
         Gtk.ResponseType result = (ResponseType)dialog_delete_file.run ();
         dialog_delete_file.destroy();
         if(result==Gtk.ResponseType.OK){
         FileUtils.remove (directory_path+"/"+item);
         if(file.query_exists()){
            alert("Delete failed");
         }else{
             show_notes();
         }
      }
   }
   
   private void go_to_list_page(){
        stack.visible_child = vbox_list_page;
        set_buttons_on_list_page();
   }
   
   private void go_to_name_page(){
        stack.visible_child = vbox_name_page;
        set_buttons_on_name_page();
   }
   
   private void on_view_clicked(){
         var selection = tree_view.get_selection();
           selection.set_mode(SelectionMode.SINGLE);
           TreeModel model;
           TreeIter iter;
           if (!selection.get_selected(out model, out iter)) {
               alert("Choose a note");
               return;
           }
        stack.visible_child = vbox_view_page;
        set_buttons_on_view_page();
        string text;
            try {
                FileUtils.get_contents (directory_path+"/"+item, out text);
            } catch (Error e) {
               stderr.printf ("Error: %s\n", e.message);
            }
            view.buffer.text = text;
   }
   
   private void on_save_clicked(){
         if(is_empty(text_view.buffer.text)){
             alert("Nothing to save");
             return;
         }
         GLib.File file = GLib.File.new_for_path(directory_path+"/"+note_name);
        var dialog_save_file = new Gtk.MessageDialog(this, Gtk.DialogFlags.MODAL,Gtk.MessageType.QUESTION, Gtk.ButtonsType.OK_CANCEL, "Save note "+file.get_basename()+" ?");
         dialog_save_file.set_title("Question");
         Gtk.ResponseType result = (ResponseType)dialog_save_file.run ();
         if(result==Gtk.ResponseType.OK){
         try {
            FileUtils.set_contents (file.get_path(), text_view.buffer.text);
        } catch (Error e) {
            stderr.printf ("Error: %s\n", e.message);
        }
          show_notes();
      }
      dialog_save_file.destroy();
   }
   
   private void on_clear_clicked(){
         if(is_empty(text_view.buffer.text)){
             alert("Nothing to clear");
             return;
         }
       var dialog_clear_file = new Gtk.MessageDialog(this, Gtk.DialogFlags.MODAL,Gtk.MessageType.QUESTION, Gtk.ButtonsType.OK_CANCEL, "Clear editor?");
          dialog_clear_file.set_title("Question");
          Gtk.ResponseType result = (ResponseType)dialog_clear_file.run ();
          if(result==Gtk.ResponseType.OK){
              text_view.buffer.text="";
          }
          dialog_clear_file.destroy();
   }
   
   private void on_ok_clicked(){
        if(is_empty(entry_name.get_text())){
             alert("Enter the name");
             entry_name.grab_focus();
             return;
         }
         note_name = entry_name.get_text().strip();
        switch(mode){
            case 0:
		GLib.File select_file = GLib.File.new_for_path(directory_path+"/"+item);
		GLib.File edit_file = GLib.File.new_for_path(directory_path+"/"+note_name);
		if (select_file.get_basename() != edit_file.get_basename() && !edit_file.query_exists()){
                FileUtils.rename(select_file.get_path(), edit_file.get_path());
                if(!edit_file.query_exists()){
                    alert("Rename failed");
                    return;
                }
                show_notes();
            }else{
                if (select_file.get_basename() != edit_file.get_basename()) {
                    alert("A note with the same name already exists");
                    entry_name.grab_focus();
                    return;
                }
            }
            stack.visible_child = vbox_edit_page;
            set_buttons_on_edit_page();
            string text;
            try {
                FileUtils.get_contents (directory_path+"/"+note_name, out text);
            } catch (Error e) {
               stderr.printf ("Error: %s\n", e.message);
            }
            text_view.buffer.text = text;
            break;
            case 1:
	GLib.File file = GLib.File.new_for_path(directory_path+"/"+note_name);
        if(file.query_exists()){
            alert("A note with the same name already exists");
            entry_name.grab_focus();
            return;
        }
        stack.visible_child = vbox_edit_page;
        set_buttons_on_edit_page();
        if(!is_empty(text_view.buffer.text)){
              text_view.buffer.text = "";
        }
        break;
      }
   }
   
   private void on_select_item () {
           var selection = tree_view.get_selection();
           selection.set_mode(SelectionMode.SINGLE);
           TreeModel model;
           TreeIter iter;
           if (!selection.get_selected(out model, out iter)) {
               return;
           }
           TreePath path = model.get_path(iter);
           var index = int.parse(path.to_string());
           if (index >= 0) {
               item = list.nth_data(index);
           }
       }
   
   private void show_notes () {
           list_store.clear();
           list = new GLib.List<string> ();
            try {
            Dir dir = Dir.open (directory_path, 0);
            string? file_name = null;
            while ((file_name = dir.read_name ()) != null) {
                list.append(file_name);
            }
        } catch (FileError err) {
            stderr.printf (err.message);
        }
         TreeIter iter;
           foreach (string item in list) {
               list_store.append(out iter);
               list_store.set(iter, Columns.TEXT, item);
           }
       }
   
   private bool is_empty(string str){
        return str.strip().length == 0;
      }
   
       private enum Columns {
           TEXT, N_COLUMNS
       }
    
    private string date_time(){
         var now = new DateTime.now_local ();
         return now.format("%x  %X");
    }
    
    private void set_widget_visible (Gtk.Widget widget, bool visible) {
         widget.no_show_all = !visible;
         widget.visible = visible;
  }
       
       private void set_buttons_on_edit_page(){
       set_widget_visible(back_button_view_page,false);
       set_widget_visible(back_button_edit_page,true);
       set_widget_visible(back_button_name_page,false);
       set_widget_visible(save_button,true);
       set_widget_visible(delete_button,false);
       set_widget_visible(edit_button,false);
       set_widget_visible(clear_button,true);
       set_widget_visible(add_button,false);
       set_widget_visible(view_button,false);
   }
       
       private void set_buttons_on_list_page(){
       set_widget_visible(back_button_view_page,false);
       set_widget_visible(back_button_edit_page,false);
       set_widget_visible(back_button_name_page,false);
       set_widget_visible(save_button,false);
       set_widget_visible(delete_button,true);
       set_widget_visible(edit_button,true);
       set_widget_visible(clear_button,false);
       set_widget_visible(add_button,true);
       set_widget_visible(view_button,true);
       }
       
       private void set_buttons_on_view_page(){
       set_widget_visible(back_button_view_page,true);
       set_widget_visible(back_button_edit_page,false);
       set_widget_visible(back_button_name_page,false);
       set_widget_visible(save_button,false);
       set_widget_visible(delete_button,false);
       set_widget_visible(edit_button,false);
       set_widget_visible(clear_button,false);
       set_widget_visible(add_button,false);
       set_widget_visible(view_button,false);
       }
       
       private void set_buttons_on_name_page(){
       set_widget_visible(back_button_view_page,false);
       set_widget_visible(back_button_edit_page,false);
       set_widget_visible(back_button_name_page,true);
       set_widget_visible(save_button,false);
       set_widget_visible(delete_button,false);
       set_widget_visible(edit_button,false);
       set_widget_visible(clear_button,false);
       set_widget_visible(add_button,false);
       set_widget_visible(view_button,false);
       }
    
    private void alert (string str){
          var dialog_alert = new Gtk.MessageDialog(this, Gtk.DialogFlags.MODAL, Gtk.MessageType.INFO, Gtk.ButtonsType.OK, str);
          dialog_alert.set_title("Message");
          dialog_alert.run();
          dialog_alert.destroy();
       }  
  }
}
