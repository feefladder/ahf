using UnityEngine;


public class CropHandler : MonoBehaviour {
    public AssetManager assetManager;
    public StateHandler stateHandler;

    void Start() {
        stateHandler.OnTryPlaceItem += TryPlaceCrop;
    }

    public void TryPlaceCrop(PlaceableItem item, FieldBlock block) {
        var crop = (Crop)item;
        if(crop.item_name != "Remove") {
            if (!block.IsCropPlanted()) {
                if (!assetManager.DecreaseAssets(crop.per_field_cost, crop.per_field_labour)) {
                    block.PlantCrop(crop);
                }
            }
        } else {
            if(block.IsCropPlanted()) {
                assetManager.IncreaseAssets(block.currentCrop.per_field_cost, block.currentCrop.per_field_labour);
                block.RemoveCrop();
            }
        }
    }
}