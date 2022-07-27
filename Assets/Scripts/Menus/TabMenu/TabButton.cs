using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.EventSystems;

[RequireComponent(typeof(Image))]
public class TabButton : MonoBehaviour, IPointerEnterHandler, IPointerExitHandler, IPointerDownHandler
{
    public TabMenu tabMenu;
    public Image background;
    public Tab tab;

    public void OnPointerEnter(PointerEventData eventData){
        tabMenu.OnTabEnter(this);
    }

    public void OnPointerExit(PointerEventData eventData){
        tabMenu.OnTabExit(this);
    }

    public void OnPointerDown(PointerEventData eventData){
        tabMenu.OnTabSelected(this, tab);
    }

    public void OnDeselect(){
        tabMenu.OnTabDeselected(this);
    }
}
