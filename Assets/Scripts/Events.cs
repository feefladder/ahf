using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Events 
{
    
    
    public string info;
    public Sprite eventSprite;
 
    // Start is called before the first frame update
    void Start()
    {

    }


    public virtual void Operation(Decision_Handler Handler)
    {
        Handler.event_text.text = info;
        if(eventSprite!=null){
        Handler.eventImage.sprite= eventSprite;}
    }
}
    public class Drought : Events
    { public Drought() { 
        info="Low rainfall resulted in a severe drought during the growing season. You lost 25% of you crop production.";
            }
        public override void Operation(Decision_Handler Handler)
        {
            if (Handler.isdripirrigation)
            {
                return;
            }
            else
            {
                for (int i = 0; i < Handler.Crop_Handler.uicrops.Count; i++)
                {
                    Handler.Crop_Handler.uicrops[i].loss = 25;
                }
            }
        }

    }
    public class Disease : Events
    {
        public Disease()
        {
            info = "There was an outbreak of a crop disease affecting all your crops. You lost 30% of your crop production.";
            
        }
        public override void Operation(Decision_Handler Handler)
        {
        Handler.event_text.text = info;
        if (Handler.isdripirrigation.isOn)
            {
                return;
            }
            else
            {
                for (int i = 0; i < Handler.Crop_Handler.uicrops.Count; i++)
                {
                    Handler.Crop_Handler.uicrops[i].loss = 30;
                }
            }
        }

    }
    public class Gullying : Events
    {
        public Gullying()
        {
            info = "Intense rainstorms resulted in large gully formations on your field. 20% of your crops were washed away. With terraces, your field was protected. With grass strips, the results were less severe, you lost 10% of your crops.";
        }
        public override void Operation(Decision_Handler Handler)
        {
        Handler.event_text.text = info;
        if (Handler.isgrassstripplaced.isOn)
            {
                return;
            }
            else if (Handler.isterracebuilt.isOn)
            {
                for (int i = 0; i < Handler.Crop_Handler.uicrops.Count; i++)
                {
                    Handler.Crop_Handler.uicrops[i].loss = 10;
                }
            }
            else
            {
                for (int i = 0; i < Handler.Crop_Handler.uicrops.Count; i++)
                {
                    Handler.Crop_Handler.uicrops[i].loss = 20;
                }
            }
        }

    }
    public class Insects : Events
    {
        public Insects()
        {
            info = "All your crops were affected by an insect plague. You lost 30% of your production. If you applied pesticides, your crops remained unharmed.";
        }
        public override void Operation(Decision_Handler Handler)
        {
        Handler.event_text.text = info;

        for (int i = 0; i < Handler.Crop_Handler.uicrops.Count; i++)
            {
                if (Handler.Crop_Handler.uicrops[i].pesticide.isOn)
                {

                }
                else
                {
                    Handler.Crop_Handler.uicrops[i].loss = 30;
                }
            }
        }

    }
    public class LivingCosts : Events
    {
        public LivingCosts()
        {
            info = "Market prices for general living goods were increased due to inflation. Thus, your living expenses were increased by 20%.";
            
        }
        public override void Operation(Decision_Handler Handler)
        {
        Handler.event_text.text = info;
    
        Handler.basic_expenses += Handler.basic_expenses * (20 / 100);

        }
    }
    public class LowmarketPrice : Events
    {
        public LowmarketPrice()
        {
            info = "Because of over-production in the region, market values for your crops were low. You receives 10% less income from the harvest of all your crops except coffee.";
        }
        public override void Operation(Decision_Handler Handler)
        {
        Handler.event_text.text = info;
        for (int i = 0; i < Handler.Crop_Handler.uicrops.Count; i++)
            {
                Handler.Crop_Handler.uicrops[i].loss = 10;

            }
        }

    }
    public class Illness : Events
    {
        public Illness()
        {
            info = "One of your family members nearly died from a severe malaria infection and had to be hospitalized. This costs you 4000 Tshs in expenses.";
        }
        public override void Operation(Decision_Handler Handler)
        {
        Handler.event_text.text = info;
        if (Handler.health_insurance)
                {

                }
                else
                {
                Handler.healthbills = 4000;
                }
            
        }

    }

   

