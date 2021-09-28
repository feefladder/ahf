using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class Decision_Handler : MonoBehaviour
{
    #region variables
    //static public Decision_Handler instance { get { return s_Instance; } }
    public Decision_Handler s_Instance;
    [Header("Farm parameters")]
    public List<Crops> crops = new List<Crops>(10);
    public int money = 1000000;
    public int fertility=60;
    public int salinity;
    public int labor=250;
    //public Toggle manureapplied;
    public Toggle isterracebuilt;
    public bool isterracemaintained;
    public Toggle isgrassstripplaced;
    public Toggle isdripirrigation;
    public Toggle isgreenhousebuilt;
    public Toggle washfield;
    public int years = 1;
    public int labor_cost = 1000;
    public Toggle hire_labor;
    public int off_farm_job = 2000;
    public Toggle isofffarmjob;
    public int Chnum,Conum,Gonum;
    public GameObject Nomoney,Nolabour;
    public int newcow,newgoat,newchicken;
    public Chicken c;
    public Goat g;
    public Cow cow;
    public int startamount;

    [Header("Family parameters")]
    public Children eldest = new Children(18,4,true,false,false);
    public Children second = new Children(12, 0, true, false, false);
    public Toggle health_insurance;
    public Toggle birth_control;
    public int HI_cost = 1500;
    public int HI_inperchild = 500;
    public int basic_expenses = 5000;
    public int increment_per_child = 750;
    public int school_fees = 1000;
    public int birth_cost = 300;
    public List<Children> kids = new List<Children>();
    public int sec_kids;
    public int uni_kids;
    int seckidsavailable=0;
    int unikidsavailable = 0;
    public Text seckids;
    public Text unikids;
    public Text secavai;
    public Text uniavai;
    public Toggle buy_house;
    public Toggle buy_car;
    public int house = 15000;
    public int car = 10000;

    [Header("UI")]
    public GameObject grass_strips, terraces;
    public Text Money, Fertility, Salinity, Labor, Year, cownum, chickennum, goatnum,
    cowcount, chickencount, goatcount;
    public Image[] crop_placeholders;
    public Sprite blank;
    public List<Crops> uicrops;
    public Text[] cropprices;
    public Button sectog, unitog;


    [HideInInspector]
    public int total_income;
    public int total_expenses;
  
    #endregion

    void Start()
    {
        
        kids.Add(eldest);
        kids.Add(second);
        startamount = money;
        Year.text = years.ToString();
        
       


    }


    void Update()
    {
        #region toggles
        
        if (HI_cost+(kids.Count*HI_inperchild)> money)
        {
            health_insurance.interactable = false;
        }
        if (labor<25)
        {
            isgrassstripplaced.interactable = false;
        }
        if (labor < 25)
        {
            isterracebuilt.interactable = false;
        }
        if (birth_cost > money)
        {
            birth_control.interactable = false;
        }
        if (house> money)
        {
            buy_house.interactable = false;
        }
        if (car > money)
        {
            buy_car.interactable = false;
        }
        for (int i = 0; i < uicrops.Count; i++)
        {
            if (uicrops[i].pest_price>money)
            {
                uicrops[i].pesticide.interactable = false;
            }
            
        }

        //drip here
        #endregion
        chickennum.text = chickencount.text;
        goatnum.text = goatcount.text;
        cownum.text = cowcount.text;
        Money.text = money.ToString();
        Labor.text = labor.ToString();
        
            for (int i = 0; i < cropprices.Length; i++)
        {
            cropprices[i].text= uicrops[i].seed_cost.ToString();
            
        }
        if (seckidsavailable + unikidsavailable < kids.Count)
        {
            foreach (Children child in kids)
            {
                if (!child.primarycomplete)
                {

                }
                if (!child.sec_complete)
                {
                    seckidsavailable += 1;
                }

                if (!child.uni_complete)
                {
                    unikidsavailable += 1;
                }
            }
        }
                if (sec_kids >= seckidsavailable)
                {
                    sectog.interactable = false;
                }

                if (uni_kids >= unikidsavailable)
                {
                    unitog.interactable = false;
                }
            
        
        
        seckids.text = sec_kids.ToString();
        unikids.text = uni_kids.ToString();
        secavai.text = seckidsavailable.ToString();
        uniavai.text = unikidsavailable.ToString();
    }

    #region Livestock functions
    
    public void Add_livestock( Livestock type)
     {

        if (type.type == "Cow")
        {
            if (Conum == type.max)
            {
                return;
            }
        }
        if (type.type == "Chicken")
        {
            
            if (Chnum == type.max) {
                
            return; }
        }
        if (type.type == "Goat")
        {
            if (Gonum == type.max) { 
            return; }
        }

        if (money >= type.cost)
        {
            money -= type.cost;
            total_expenses += type.cost;
            
        }
        else {
            Nomoney.SetActive(true);
            return;
        }
        if (labor >= type.required_labor)
        {
            labor -= type.required_labor;
            
        }
        else
        {
            Nolabour.SetActive(true);
            return;
        }
        
        if (type.type == "Cow") {
            Conum += 1;
            cowcount.text = Conum.ToString();
            newcow += 1;
            
        }

        if (type.type == "Goat") {
            Gonum += 1;
            goatcount.text = Gonum.ToString();
            newgoat += 1;

        }
        if (type.type == "Chicken") {
            Chnum += 1;
            newchicken += 1;
            chickencount.text = Chnum.ToString();
            

        }  
     }

    public void Remove_livestock(Livestock type)
    {
       if (type.type == "Cow" & Conum>=1)
        {
            Conum -= 1;
            if (newcow == 0)
            {
                money += type.cost-(type.cost*(10/100));
            }
            else { newcow -= 1; money += type.cost; }
            labor += type.required_labor;
            //total_expenses -= type.cost;
            cowcount.text = Conum.ToString();
        }

        if (type.type == "Goat" & Gonum>=1)
        {
            Gonum -= 1;
            if (newgoat == 0)
            {
                money += type.cost - (type.cost * (10 / 100));
            }
            else { newgoat -= 1; money += type.cost; }
            labor += type.required_labor;
           // total_expenses -= type.cost;
            goatcount.text = Gonum.ToString();
        }
        if (type.type == "Chicken" & Chnum>=1)
        {
            Chnum -= 1;
            if (newchicken == 0)
            {
                money += type.cost - (type.cost * (10 / 100));
            }
            else { newchicken -= 1; money += type.cost; }
            labor += type.required_labor;
            //
total_expenses -= type.cost;
            chickencount.text = Chnum.ToString();
        }
    }

    public int Livestockexpense()
    {
        int expense = 0;
        
        expense += (c.cost * Chnum) + (g.cost * Gonum) + (cow.cost * Conum);

        return expense;
    }
    public int LivestockIncome()
    {
        int income = 0;
        income += (c.product_revenue * Chnum) + (g.product_revenue * Gonum) + (cow.cost * Conum);
        return income;
    }
    #endregion

    #region Crops -_-
    public void PurchaseCrops(Crops type)
    {   if (crops.Count <= 9)
        {
            
            if (money >= type.seed_cost)
            {
                money -= type.seed_cost;
                total_expenses += type.seed_cost;

            }
            else
            {
                Nomoney.SetActive(true);
                return;
            }
            if (labor >= type.required_labor)
            {
                labor -= type.required_labor;
            }
            else
            {
                Nolabour.SetActive(true);
                return;
            }
            crops.Add(type);
            foreach (Crops c in uicrops)
            {
                c.num = 0;
                for (int i = 0; i < crops.Count; i++)
                {
                    if (crops[i] == c)
                    {
                        c.num++;
                    }

                }
                c.displaynumber.text = c.num.ToString();
            }
            for (int i = 0; i < crops.Count; i++)
            {
                
                if (crops[i] != null)
                {
                    crop_placeholders[i].sprite = crops[i].sprite;
                }
                else
                {
                    crop_placeholders[i].sprite = blank;
                }
            }

        }
    }

    public void  SellCrops(Crops type)
    {
        if (!crops.Contains(type))
        {
            return;
        }
        money += type.seed_cost;
        total_expenses -= type.seed_cost;
        labor += type.required_labor;
        
        //crop_placeholders[crops.LastIndexOf(type)].sprite=blank;
        crops.Remove(type);
        foreach (Crops c in uicrops)
        {
            c.num = 0;
            for (int i = 0; i < crops.Count; i++)
            {
                if (crops[i] == c)
                {
                    c.num++;
                }

            }
            c.displaynumber.text = c.num.ToString();
        }
        for (int i = 0; i < crops.Capacity; i++)
        {
            crop_placeholders[i].sprite = blank;
            
        }
        for (int i = 0; i < crops.Count; i++)
        {

            if (crops[i] != null)
            {
                crop_placeholders[i].sprite = crops[i].sprite;
            }
            else
            {
                crop_placeholders[i].sprite = blank;
            }
        }
    }
    
    #endregion

    #region Family

    public void School(int grade)
    {
        if (grade == 0 )
        {
            if (money > school_fees)
            {
                seckidsavailable--;
                sec_kids++;
            }else
        {
            Nomoney.SetActive(true);
        }
        }
        
        if (grade == 1 )
        {
            if (money > school_fees * 1.5)
            {
                unikidsavailable--;
                uni_kids++;
            }
            else
            {
                Nomoney.SetActive(true);
            }
        }
        
    }
    
    public  void RevomeSchool(int grade)
    {
        if (grade == 0)
        {
            if (sec_kids>0)
            {
                seckidsavailable ++;
                sec_kids --;
            }
        }
        if (grade == 1)
        {
            if (uni_kids > 0)
            { 
                unikidsavailable ++;
                uni_kids --;
            }
        }
    }
    public int Familyexpense()
    {
        int expenses=0;
        if (health_insurance.isOn)
        {
           expenses+= HI_cost + kids.Count * HI_inperchild;
        }
        if (birth_control.isOn)
        {
            expenses += birth_cost;
        }
        if (buy_house.isOn)
        {
            expenses += house;
        }
        if (buy_car.isOn)
        {
            expenses += car;
        }
        expenses += school_fees*sec_kids+((school_fees*2)*uni_kids);
        expenses += basic_expenses + (increment_per_child * kids.Count);
        
        return expenses;

    }
    public int Familyrevenue()
    {
        int revenue = 0;
        foreach (Children kid in kids)
        {
            if (kid.uni_complete)
            {
                revenue += 700;
            }
        }
        return revenue;
    }
  
    
    #endregion

    #region Annual Review
    #region variables
    public GameObject panel;
    //so 
    //many
    //textboxes -_-
    
    public Text t_expenses, t_income, start_amount, year, household, net_total,
    llc_expense, llc_income, crop_inc, crop_ex;
    public Image net;
    public Image farmzy;
    //event variables
    public int healthbills;
   // public int loss;
    int living_increase;
    #endregion
    public void Play()
    {
        Event();
        int totalinc = 0;
        int totalex = 0;
        int laborin = 0;
        int laborex = 0;
        
        if (isofffarmjob.isOn)
        {
            laborin = off_farm_job;
        }
        if (hire_labor.isOn)
        {
            laborex = labor_cost;
        }
        for (int i = 0; i < uicrops.Count; i++)
        {
            if (uicrops[i].pesticide.isOn)
            {
                totalex += uicrops[i].pest_price;
            }
        }
        start_amount.text = startamount.ToString();
       

        household.text = "2 Adults + "+kids.Count.ToString()+ " Children";
        llc_expense.text = Livestockexpense().ToString() + "\n" + laborex + "\n" + Familyexpense().ToString() + "\n" + healthbills.ToString();
        llc_income.text = LivestockIncome().ToString() + "\n" + laborin+ "\n" + Familyrevenue().ToString();

        foreach (Crops c in uicrops)
        {
            c.num = 0;
            for (int i = 0; i < crops.Count; i++)
            {
                if (crops[i]=c)
                {
                    c.num++;
                }
            }
            c.area = c.num / 100;
            c.totalincome= ((c.area * c.base_yield * c.unitprice) +(c.base_yield * fertility))-(c.base_yield*(c.loss/100)) +(c.base_yield*(c.profit/100));
            c.totalexpense = c.area * c.seed_cost + c.pest_price;
            totalex += c.totalexpense;
            totalinc += c.totalincome;
            c.income_dets.text = c.unitprice.ToString() + ".00   "+c.area.ToString() +"%    "+fertility.ToString()+"%   "+c.loss.ToString()+"%" ;
            c.expense_dets.text = c.seed_cost.ToString() + ".00   " + c.area.ToString() + "%        " + c.pest_price.ToString();
            crop_ex.text = uicrops[0].totalexpense.ToString() + "AHC"+ "\n" + uicrops[1].totalexpense.ToString() + "AHC" + "\n"
                + uicrops[2].totalexpense.ToString() + "AHC" + "\n" +uicrops[3].totalexpense.ToString();
            crop_inc.text = uicrops[0].totalincome.ToString() + "AHC" + "\n" + uicrops[1].totalincome.ToString() + "AHC" + "\n"
                + uicrops[2].totalincome.ToString() + "AHC" + "\n" + uicrops[3].totalincome.ToString();
            c.loss = 0;
            c.totalexpense = 0;
            c.totalincome = 0;
        }
        totalex += Livestockexpense() + Familyexpense() + healthbills+laborex;
        totalinc += LivestockIncome() + Familyrevenue() + laborin;
        t_expenses.text = totalex.ToString();
        t_income.text = total_income.ToString();
        print(totalex); print(totalinc); print(money);
        money += totalinc - totalex;
        net_total.text = money.ToString();
        startamount = money;
        if (money>0)
        {
            net.color = Color.green;
        }
        else
        {
            net.color = Color.red;
        }
        
        #region salinity
        if (isdripirrigation)
        {
            salinity += 25;
        }
        if (washfield)
        {
            salinity = 0;
        }
        fertility -= 15;
        if (salinity==75)
        {
            fertility -= 50;
        }
        if (salinity==100)
        {
            fertility = 100;
        }
        if (isgrassstripplaced)
        {
            fertility += 20;
        }
        #endregion
        panel.SetActive(true);
        healthbills = 0;
        if (years<=12)
        {
            years++;
            Year.text = years.ToString();
        }
        else
        {
            End();
        }
    }
    public void Event()
    {
      
        Events events = new Events();
        int evento = Random.Range(0, 6);

        if (evento == 0)
        {
            events = new Disease();
        }

        if (evento == 1)
        {
            events = new Drought();
        }
        if (evento == 2)
        {
            events = new Gullying();
        }
        if (evento == 3)
        {
            events = new Illness();
        }
        if (evento == 4)
        {
            events = new Insects();
        }
        if (evento == 5)
        {
            events = new LivingCosts();
        }
        if (evento == 0)
        {
            events = new LowmarketPrice();
        }
        events.Operation(s_Instance);
    }
    public void End()
    {

    }
    #endregion


   
}
