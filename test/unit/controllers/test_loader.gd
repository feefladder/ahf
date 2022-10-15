extends GutTest

var loader: Loader
var measure: MeasureResource
var crop_01: CropResource
var crop_02: CropResource


func before_each():
    measure = load("res://test/unit/resources/measures/01_terraces.tres")
    crop_01 = load("res://test/unit/resources/crops/irish_potato.tres")
    crop_02 = load("res://test/unit/resources/crops/maize.tres")
    loader = partial_double(Loader).new()
    loader.base_path = "res://test/unit/resources/"
    loader.resources_paths = {}
    watch_signals(loader)
    # add_child(loader)

func test___load_resources_measure():
    assert_eq(loader._load_resources("measures/"),[measure])

func test__load_resources_crops():
    assert_eq(loader._load_resources("crops/"), [crop_01, crop_02 ])

func test_signal_measure():
    loader.resources_paths = {"measures": "measures/"}
    add_child_autoqfree(loader)
    assert_signal_emitted_with_parameters(loader, "resources_loaded", ["measures", [measure]])

func test_signal_crops():
    loader.resources_paths = {"crops": "crops/"}
    add_child_autofree(loader)
    assert_signal_emitted_with_parameters(loader, "resources_loaded", ["crops", [crop_01, crop_02]])

func test_signal_both():
    loader.resources_paths = {"measures": "measures/", "crops": "crops/"}
    add_child_autofree(loader)
    assert_signal_emitted_with_parameters(loader, "resources_loaded", ["measures", [measure]], 0)
    assert_signal_emitted_with_parameters(loader, "resources_loaded", ["crops", [crop_01, crop_02]], 1)

func test_signal_non_existent_folder():
    loader.resources_paths = {"non_existent_folder": "non_existent_folder/"}
    add_child_autofree(loader)
    assert_signal_emitted_with_parameters(loader, "resources_loaded", ["non_existent_folder", []])

func test_signal_no_resource_folder():
    # test a folder with no resource, but script files, should return empty
    loader.resources_paths = {"family": "family/"}
    add_child_autofree(loader)
    assert_signal_emitted_with_parameters(loader, "resources_loaded", ["family", []])
