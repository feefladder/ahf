using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class End : MonoBehaviour
{
    public GameObject endpanel, angry_farmzy, normal_farmzy,
        happy_farmzy;
    public Text info;
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
    }

    public void Quit()
    {
        Application.Quit();
    }

    
}
