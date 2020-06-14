using UnityEngine;
using UnityEngine.UI;
using System.Collections;

[RequireComponent(typeof(Text))]
public class NumMazeText : MonoBehaviour {
    public static int numMaze = 0;
    private Text text;
	
    // Use this for initialization
	void Start () {
		text = GetComponent<Text>();
	}

	// Update is called once per frame
	void Update () {
		if (numMaze > 0) {
			text.text = "Maze: " + numMaze;
		}
	}
}
