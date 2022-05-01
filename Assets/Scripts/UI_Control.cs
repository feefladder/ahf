using System.Collections;
using System.Collections.Generic;
using UnityEngine;



public class UI_Control : MonoBehaviour
{
   
   public GameObject game, main;
   
   

    public void ToggleSound( bool value)
     {
         
 
         if (value)
             AudioListener.volume = 1f;
 
         else
             AudioListener.volume = 0f;
     }

    

     public void ReturnToMain() 
     {
         game.SetActive(false);
         main.SetActive(true);
     }
}
