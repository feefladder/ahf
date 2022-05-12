using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.Events;


public class End : MonoBehaviour
{
    public GameObject gamepanel, angry_farmzy, normal_farmzy,
        happy_farmzy, sad_farmzy;
    public Text info;
    public UnityEvent quit;
    void Start()
    {
        
    }

    public void GameOver(string condition)
    {
        if (condition=="bad")
        {
            angry_farmzy.SetActive(true);
            info.text = "You finished 15 years of farming, but your future is insecure. Whether you took little preventive measures or lacked to invest in sustainable land management, livestock and/ or your children.Therefore you are definitely not cut out to be a farmer. How do you expect to survive like this ? !";
        }
        if (condition=="good")
        {
            normal_farmzy.SetActive(true);
            info.text = "Well Done";
        }
        if (condition=="very good")
        {
            happy_farmzy.SetActive(true);
            info.text = "Very well done";
        }
        if (condition=="lose")
        {
            sad_farmzy.SetActive(true);
            info.text = "You ended the year in debt twice in a row and have lost the game. Too bad.";
        }
    }

    public void Quit()
    {
        Rerun();
        AudioListener.volume=0f;
        quit.Invoke();
        
    }

    public void Rerun( )
    {
       
        angry_farmzy.SetActive(false);
        normal_farmzy.SetActive(false);
        happy_farmzy.SetActive(false);
        sad_farmzy.SetActive(false);
        gameObject.SetActive(false);
    }
         
}
