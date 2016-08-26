using UnityEngine;
using System.Collections;

public class LightDemo : MonoBehaviour
{
	void Update ()
	{
		transform.Rotate(Vector3.up, 30 * Time.deltaTime, Space.World);
	}
}
