
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class Menu : MonoBehaviour
{
    public GameObject[] story_images;
    public int story_counter = 0;
    public string[] story_text;
    public GameObject storytextbox;
    public GameObject Game;
    
    void Start()
    {
        
    }

   

    public void openurl(string text)
    {
        Application.OpenURL(text);
    }
    public void openpdf()
    {
        Application.OpenURL(Application.persistentDataPath+"/tutorial.pdf");
        print(Application.persistentDataPath + "/tutorial.pdf");
    }

    public void Nextpane()
    {
        if (story_counter > 4)
            return;
        story_images[story_counter].SetActive(false);
        story_counter += 1;
        if (story_counter > 4)
        {
            Game.SetActive(true);

        }
        storytextbox.GetComponent<Text>().text = story_text[story_counter];
        story_images[story_counter].SetActive(true);
        

    }

}
