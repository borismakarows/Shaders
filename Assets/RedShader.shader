Shader "Unlit/TestShader"
{
    Properties
    { //input data
        //_MainTex ("Texture", 2D) = "white" {}
        _Color ("Color", Color) = (1,0,0,1) //texture is complicated for now so we deleted
    }
    SubShader //sample of a proper shader
    {
        Tags { "RenderType"="Opaque" } 

        Pass
        {
            CGPROGRAM //shader code starts
            #pragma vertex vert //pointing the functions 
            #pragma fragment frag

            #include "UnityCG.cginc" //contain unity specific things 

            float4 _Color;

            struct MeshData //per-vertex mesh data 
            {
                float4 vertex : POSITION; // vertex position
                float2 uv : TEXCOORD0; // uv0 coordinates 
                //float2 uv: TEXCOORD1; // uv1 coordinates 
                //float3 normals: NORMAL; // physics normal, normal direction of vertex
                //float4 color: COLOR; // color of vertices
                //float4 tangent: TANGENT; // 
            };

            struct InterPolators // data: vertex to fragment shader
            {
                //float2 uv : TEXCOORD0; 
                float4 vertex : SV_POSITION;// clip space position
            };

            

            InterPolators vert (MeshData v)
            {
                InterPolators o;
                o.vertex = UnityObjectToClipPos(v.vertex); // local space to clip space
                return o;
            }

            
            //int 
            // bool 0 1
            // float (32 bit float)
            // half (16 bit float)
            // fixed (lower precision) -1 to 1
            // float4 -> half4 -> fixed4

            
            fixed4 frag (InterPolators i) : SV_Target //output target
            {
    
                return _Color;
            }
            ENDCG
        }
    }
}
