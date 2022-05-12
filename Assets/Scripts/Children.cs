using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Children 
{ 
    public int age;
    public int stage_in_school;
    public bool primarycomplete;
    public bool sec_complete;
    public bool uni_complete;

    public Children(int Age, int sts, bool pc, bool sec, bool uni)
    {
        age = Age;
        stage_in_school = sts;
        primarycomplete = pc;
        sec_complete = sec;
        uni_complete = uni;
    }
        
}
