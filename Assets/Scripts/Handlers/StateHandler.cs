using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class StateHandler: MonoBehaviour
{
    public List<BuyMenu> buyMenus;
    public Field field;
    public event Action<PlaceableItem, FieldBlock> OnTryPlaceItem;
    [Serializable]
    public enum States {PlacingItems, Idle};
    [SerializeReference] private States currentState;

    public PlaceableItem currentItem;

    void Start(){
        foreach (BuyMenu buyMenu in buyMenus){
            buyMenu.OnItemClicked += SetPlacingItem;
        }

        field.OnFieldPointed += DoIPlaceItems;
    }

    public void SetPlacingItems(bool amIPlacing) {
        currentState = amIPlacing ? States.PlacingItems : States.Idle;
        Debug.Log("changed state to: " + currentState);
    }

    public void SetPlacingItem(PlaceableItem item) {
        currentItem = item;
    }

    public void DoIPlaceItems(FieldBlock aBlock) {
        if(currentItem != null && currentState == States.PlacingItems) {
            Debug.Log("Placing item " + currentItem);
            OnTryPlaceItem?.Invoke(currentItem, aBlock);
        }
    }
}