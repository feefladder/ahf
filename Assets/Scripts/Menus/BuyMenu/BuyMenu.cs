using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BuyMenu : MonoBehaviour {
    // public VerticalLayoutGroup itemGroup;
    public GameObject ContentObject;
    public BuyMenuItem item_prefab;
    public event Action<PlaceableItem> OnItemClicked;
    public List<PlaceableItem> placeableItems;

    void Start() {
        foreach (PlaceableItem item in placeableItems) {
            var newMenuItem = (BuyMenuItem)Instantiate(item_prefab, ContentObject.transform);
            newMenuItem.InitializeFrom(item);
            newMenuItem.buyMenu = this;
        }
    }

    public void ItemClicked(PlaceableItem item) {
        OnItemClicked?.Invoke(item);
    }
}
