using System.Collections;
using UnityEngine;

[RequireComponent(typeof(Material))]
[RequireComponent(typeof(Renderer))]
public class MouseTracker : MonoBehaviour
{
    private Camera _camera;

    private Material _material;
    private Vector4 _mousePosition;


    // Start is called before the first frame update
    void Start()
    {
        var renderer = GetComponent<Renderer>();
        _material = renderer.material;

        _mousePosition = new Vector4(Screen.height, Screen.width, 0, 0);
        _camera = Camera.main;
    }

    // Update is called once per frame
    void Update()
    {
        // Raycast
        RaycastHit hit;
        var ray = _camera.ScreenPointToRay(Input.mousePosition);

        if (Physics.Raycast(ray, out hit))
        {
            _mousePosition = hit.textureCoord;
        }

        _material.SetVector("_MousePosition", _mousePosition);
    }
}
