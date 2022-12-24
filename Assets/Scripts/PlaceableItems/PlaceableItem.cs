using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(fileName="NewPlaceableItem", menuName = "PlaceableItem")]
public class PlaceableItem : ScriptableObject {
    public string item_name;
    public Sprite sprite;

    public double per_field_cost;
    public double per_field_labour;
}