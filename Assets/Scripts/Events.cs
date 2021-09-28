using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Events
{
    //public List<Events> events;
    public Sprite[] banners;
    public string info;
    //public Events e;
    //public Events d = new Drought();
    //public Events di = new Disease();
    //public Events g = new Gullying();
    //public Events i = new Illness();
    //public Events lc = new LivingCosts();
    //public Events lm = new LowmarketPrice();
    //public Events il = new Illness();
    // Start is called before the first frame update
    void Start()
    {

        //events.Add(d);
        //events.Add(di);
        //events.Add(g);
        //events.Add(i);
        //events.Add(lc);
        //events.Add(lm);
        //events.Add(il);

    }


    public virtual void Operation(Decision_Handler Handler)
    {

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
                for (int i = 0; i < Handler.uicrops.Count; i++)
                {
                    Handler.uicrops[i].loss = 25;
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
            if (Handler.isdripirrigation.isOn)
            {
                return;
            }
            else
            {
                for (int i = 0; i < Handler.uicrops.Count; i++)
                {
                    Handler.uicrops[i].loss = 30;
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
            if (Handler.isgrassstripplaced.isOn)
            {
                return;
            }
            else if (Handler.isterracebuilt.isOn)
            {
                for (int i = 0; i < Handler.uicrops.Count; i++)
                {
                    Handler.uicrops[i].loss = 10;
                }
            }
            else
            {
                for (int i = 0; i < Handler.uicrops.Count; i++)
                {
                    Handler.uicrops[i].loss = 20;
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

            for (int i = 0; i < Handler.uicrops.Count; i++)
            {
                if (Handler.uicrops[i].pesticide.isOn)
                {

                }
                else
                {
                    Handler.uicrops[i].loss = 30;
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
            for (int i = 0; i < Handler.uicrops.Count; i++)
            {
                Handler.uicrops[i].loss = 10;

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

                if (Handler.health_insurance)
                {

                }
                else
                {
                Handler.healthbills = 4000;
                }
            
        }


    }

    //public Events d = new Events.Drought();
    //public Events di = new Events.Disease();
    //public Events g = new Events.Gullying();
    //public Events i = new Events.Illness();
    //public Events lc = new Events.LivingCosts();
    //public Events lm = new Events.LowmarketPrice();
    //public Events il = new Events.Illness();

