using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class PopupInsufficient : MonoBehaviour
{
    public Text messageText;
    public string AssetName;

    // void Start(){
    //     messageText.text = "You don't have enough " + AssetName;
    // }

    public void NotEnough(int amount){
        messageText.text = "You don't have enough " + AssetName + ". Need " + amount + " more!";
    }
}
