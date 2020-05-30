
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
private string directory_path;
private string note_name;
private string item;
private int mode;

        public MainWindow(Gtk.Application application) {
            GLib.Object(application: application,
                         title: "Notepad",
                         window_position: WindowPosition.CENTER,
                         resizable: true,
                         height_request: 350,
                         width_request: 450,
                         border_width: 10);
        }        

        construct {        
          stack = new Stack();
          stack.set_transition_duration (600);
          stack.set_transition_type (StackTransitionType.SLIDE_LEFT_RIGHT);
          add (stack);
        var toolbar_list_page = new Toolbar ();
        toolbar_list_page.get_style_context ().add_class (STYLE_CLASS_PRIMARY_TOOLBAR);
        var add_icon = new Gtk.Image.from_icon_name ("document-new", IconSize.SMALL_TOOLBAR);
        var view_icon = new Gtk.Image.from_icon_name ("document-open", IconSize.SMALL_TOOLBAR);
        var edit_icon = new Gtk.Image.from_icon_name ("document-properties", IconSize.SMALL_TOOLBAR);
        var delete_icon = new Gtk.Image.from_icon_name ("edit-delete", IconSize.SMALL_TOOLBAR);
        var add_button = new Gtk.ToolButton (add_icon, "Add New");
        add_button.is_important = true;
        var view_button = new Gtk.ToolButton (view_icon, "View");
        view_button.is_important = true;
        var edit_button = new Gtk.ToolButton (edit_icon, "Edit");
        edit_button.is_important = true;
        var delete_button = new Gtk.ToolButton (delete_icon, "Delete");
        delete_button.is_important = true;
        toolbar_list_page.add(add_button);
        toolbar_list_page.add(view_button);
        toolbar_list_page.add(edit_button);
        toolbar_list_page.add(delete_button);
        add_button.clicked.connect(on_add_clicked);
        delete_button.clicked.connect (on_delete_clicked);
        edit_button.clicked.connect(on_edit_clicked);
        view_button.clicked.connect(on_view_clicked);
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
   vbox_list_page.pack_start(toolbar_list_page,false,true,0);
   vbox_list_page.pack_start(scroll_list_page,true,true,0);
   stack.add(vbox_list_page);
        entry_name = new Entry();
        entry_name.set_icon_from_icon_name (Gtk.EntryIconPosition.SECONDARY, "edit-clear");
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
        var button_back = new Button.with_label("<<< BACK");
        button_back.clicked.connect(go_to_list_page);
        vbox_name_page = new Box(Orientation.VERTICAL,20);
        vbox_name_page.pack_start(button_back,false,true,0);
        vbox_name_page.pack_start(hbox_name,false,true,0);
        vbox_name_page.pack_start(button_ok,false,true,0);
        stack.add(vbox_name_page);
        var toolbar_edit_page = new Toolbar ();
        toolbar_edit_page.get_style_context ().add_class (STYLE_CLASS_PRIMARY_TOOLBAR);
        var back_icon = new Gtk.Image.from_icon_name ("go-previous", IconSize.SMALL_TOOLBAR);
        var save_icon = new Gtk.Image.from_icon_name ("document-save", IconSize.SMALL_TOOLBAR);
        var clear_icon = new Gtk.Image.from_icon_name ("edit-clear", IconSize.SMALL_TOOLBAR);
        var back_button = new Gtk.ToolButton (back_icon, "Back");
        back_button.is_important = true;
        var save_button = new Gtk.ToolButton (save_icon, "Save");
        save_button.is_important = true;
        var clear_button = new Gtk.ToolButton (clear_icon, "Clear");
        clear_button.is_important = true;
        toolbar_edit_page.add (back_button);
        toolbar_edit_page.add (save_button);
        toolbar_edit_page.add (clear_button);
        back_button.clicked.connect (go_to_name_page);
        save_button.clicked.connect (on_save_clicked);
        clear_button.clicked.connect (on_clear_clicked);
        this.text_view = new TextView ();
        this.text_view.editable = true;
        this.text_view.cursor_visible = true;
        this.text_view.set_wrap_mode (Gtk.WrapMode.WORD);
        var scroll_edit_page = new ScrolledWindow (null, null);
        scroll_edit_page.set_policy (PolicyType.AUTOMATIC, PolicyType.AUTOMATIC);
        scroll_edit_page.add (this.text_view);
        vbox_edit_page = new Box (Orientation.VERTICAL, 0);
        vbox_edit_page.pack_start (toolbar_edit_page, false, true, 0);
        vbox_edit_page.pack_start (scroll_edit_page, true, true, 0);
        stack.add(vbox_edit_page);
        var toolbar_view_page = new Toolbar ();
        toolbar_view_page.get_style_context ().add_class (STYLE_CLASS_PRIMARY_TOOLBAR);
        var go_to_list_page_icon = new Gtk.Image.from_icon_name ("go-previous", IconSize.SMALL_TOOLBAR);
        var go_to_list_page_button = new Gtk.ToolButton (go_to_list_page_icon, "Back");
        go_to_list_page_button.is_important = true;
        toolbar_view_page.add(go_to_list_page_button);
        go_to_list_page_button.clicked.connect(go_to_list_page);
        this.view = new TextView ();
        this.view.editable = false;
        this.view.cursor_visible = false;
        this.view.set_wrap_mode (Gtk.WrapMode.WORD);
        var scroll_view_page = new ScrolledWindow (null, null);
        scroll_view_page.set_policy (PolicyType.AUTOMATIC, PolicyType.AUTOMATIC);
        scroll_view_page.add (this.view);
        vbox_view_page = new Box(Orientation.VERTICAL,20);
        vbox_view_page.pack_start(toolbar_view_page,false,true,0);
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
   }
   
   private void go_to_name_page(){
        stack.visible_child = vbox_name_page;
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
    
    private void alert (string str){
          var dialog_alert = new Gtk.MessageDialog(this, Gtk.DialogFlags.MODAL, Gtk.MessageType.INFO, Gtk.ButtonsType.OK, str);
          dialog_alert.set_title("Message");
          dialog_alert.run();
          dialog_alert.destroy();
       }  
  }
}
