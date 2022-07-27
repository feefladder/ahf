using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;


//Field class manages instantiating field blocks, calling event handlers when
//field blocks are clicked
public class Field : MonoBehaviour
{
    public FieldBlock block_prefab;
    public Crop_Handler cropHandler;
    public event Action<FieldBlock> OnFieldPointed;
    // public Measure_Handler measureHandler;
    public Decision_Handler decisionHandler;
    // Start is called before the first frame update
    // a unit thing is 40 by 17
    // tiles are 

    public Vector3 dx = new Vector3(-28,12,0); //-182, 76
    public Vector3 dy = new Vector3(28,20,0); //184,126

    public int x_max = 3;
    public int y_max = 4;

    public FieldBlock[,] blocks;
    public bool isPointerDownOnField;

    void Start()
    {
        blocks = new FieldBlock[x_max,y_max];
        // blocks.resize(x_max,y_max);
        for(int x = x_max-1; x >=0; x--){
            for(int y=y_max-1; y >= 0; y--){
                FieldBlock block_instance = (FieldBlock)Instantiate(block_prefab, this.transform);
                block_instance.transform.position = this.transform.position + x*dx*this.transform.localScale.x +y*dy*this.transform.localScale.y;
                block_instance.field = this;
                blocks[x,y] = block_instance;
            }
        }
    }

    private (int x, int y) FindIndex(FieldBlock a_block) {
      for (int x= 0; x<x_max; x++) {
          for(int y =0; y<y_max; y++) {
              if(blocks[x,y] == a_block)
                return (x,y);
          }
      }
      return (-1,-1);
    }

    public void PointedAt(FieldBlock a_block) {
        Debug.Log("pointed at " + FindIndex(a_block));
        OnFieldPointed?.Invoke(a_block);
    }
}
