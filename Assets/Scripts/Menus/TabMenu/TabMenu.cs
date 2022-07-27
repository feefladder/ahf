using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TabMenu : MonoBehaviour
{
    public List<TabButton> tabButtons;
    private TabButton selectedButton;
    public Color tabHoverColor;
    public Color tabSelectedColor;
    public Color tabIdleColor;

    public void Subscribe(TabButton button) {
        if(tabButtons == null ){
            tabButtons = new List<TabButton>();
        }

        tabButtons.Add(button);
    }

    public void OnTabEnter(TabButton button){
        if(button != selectedButton)
            button.background.color = tabHoverColor;
    }

    public void OnTabExit(TabButton button){
        if(button != selectedButton)
            button.background.color = tabIdleColor;
    }

    public void OnTabSelected(TabButton button, Tab tab){
        //manage buttons
        if(selectedButton != null){
            DeselectTab(selectedButton, tab);
        }
        button.background.color = tabSelectedColor;
        selectedButton = button;
        //activate the tab
        if(tab)
            tab.gameObject.SetActive(true);
        
    }

    public void DeselectTab(TabButton button, Tab tab){
        selectedButton.background.color = tabIdleColor;
        if(selectedButton.tab != null){
            Debug.Log("disabling + " + selectedButton.gameObject.name);
            selectedButton.tab.gameObject.SetActive(false); //this also sets selectedButton to null
        }
    }

    public void OnTabDeselected(TabButton button){
        selectedButton = null;
        button.background.color = tabIdleColor;
    }
}
