using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class BuyMenuItem : MonoBehaviour {
    public Text buttonText;
    public Image ItemImage;
    public BuyMenu buyMenu;
    private PlaceableItem item;

    public void InitializeFrom(PlaceableItem newItem) {
        ItemImage.sprite = newItem.sprite;
        buttonText.text = newItem.item_name;
        item = newItem;
    }

    public void ItemClicked() {
        buyMenu.ItemClicked(item);
    }
}
