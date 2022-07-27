using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;

public class FieldBlock : MonoBehaviour, IPointerEnterHandler, IPointerDownHandler, IPointerUpHandler
{
    public Field field;
    public Crop currentCrop;
    public GameObject cropObject;

    // public Measure[] measures;
    public void OnPointerEnter(PointerEventData eventData)
    {
        if(field.isPointerDownOnField){
            field.PointedAt(this);
        }

    }

    // Start is called before the first frame update
    // Update is called once per frame
    public void OnPointerDown(PointerEventData eventData)
    {
        field.isPointerDownOnField = true;
        field.PointedAt(this);
    }

    public void OnPointerUp(PointerEventData eventData){
        field.isPointerDownOnField = false;
    }

    public bool IsCropPlanted() {
        if (currentCrop == null ) {
            Debug.Log("no crop planted here!");
            return false;
        } else {
            Debug.Log("Planted a " + currentCrop.item_name);
            return true;
        }
    }

    public void PlantCrop(Crop newCrop) {
        Debug.Log("planting " + newCrop);
        currentCrop = newCrop;
        cropObject.GetComponent<SpriteRenderer>().sprite = newCrop.sprite;
        cropObject.SetActive(true); 
    }

    public void RemoveCrop() {
        Debug.Log("removing " + currentCrop);
        currentCrop = null;
        // cropObject.GetComponent<SpriteRenderer>().sprite = null;
        cropObject.SetActive(false);
    }
}
