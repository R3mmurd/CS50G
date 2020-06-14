using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

public class WonText : MonoBehaviour
{
    private Text text;

    // Start is called before the first frame update
    void Start()
    {
        text = GetComponent<Text>();
        text.color = new Color(0, 0, 0, 0);
    }

    // Update is called once per frame
    void Update()
    {
        if (GoalReached.gameWon) {
            text.color = new Color(0, 0, 0, 1);
			text.text = "You won!\nPress Space to Restart!";
			
			// jump is space bar by default
			if (Input.GetButtonDown("Jump")) {
                GoalReached.gameWon = false;
				SceneManager.LoadScene("MyScene");
            }
        }   
    }

}