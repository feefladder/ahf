extends ToggleButtonContainer

export(Dictionary) var language_images_dict
export(PackedScene) var locale_tab_packedscene = preload("res://scenes/UI/tabs/ToggleButton.tscn")

func _ready():
    for lang in TranslationServer.get_loaded_locales():
        var lt_scene = locale_tab_packedscene.instance()
        lt_scene.icon = language_images_dict.get(lang)
        lt_scene.title = lang
        lt_scene.name = lang
        add_child(lt_scene)
    _connect_children()



func _on_tab_changed(tab_button):
    TranslationServer.set_locale(tab_button.name)
