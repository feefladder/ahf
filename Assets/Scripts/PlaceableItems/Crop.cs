using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(fileName="Crop", menuName = "Crop")]
public class Crop : PlaceableItem {
    public double base_yield;
    public double unit_sell_price;

    public bool CanBePlaced() {return true;}
}