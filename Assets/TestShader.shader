Shader "Unlit/TestShader"
{
    Properties
    { //input data
        //_MainTex ("Texture", 2D) = "white" {} // it's complicated for now
        _ColorA ("Color A", Color) = (1,1,1,1) 
        _ColorB("Color B", Color) = (1,1,1,1)
        _ColorStart("Color Start", Range(0,1)) = 0
        _ColorEnd("Color End",Range(0,1)) = 1
    }
    SubShader //sample of a proper shader
    {
        Tags { "RenderType"="Opaque" } 

        Pass
        {
            //pass Tags

            Blend One One // additive
            // Blend DstColor Zero // multiply


            CGPROGRAM //shader code starts
            #pragma vertex vert //pointing the functions 
            #pragma fragment frag

            #include "UnityCG.cginc" //contain unity specific things 
            #define TAU 6.283185


            float4 _ColorA;
            float4 _ColorB;
            float _ColorStart;
            float _ColorEnd;

            struct MeshData //per-vertex mesh data 
            {
                // TEXCOORDs matter here 
                float4 vertex : POSITION; // local space vertex position
                float2 uv0 : TEXCOORD0; // uv0 coordinates 
                float3 normals: NORMAL; // local space physics normal, normal direction of vertex
                 //float2 uv: TEXCOORD1; // uv1 coordinates 
                //float4 color: COLOR; // color of vertices
                //float4 tangent: TANGENT; // 
            };

            struct InterPolators // data: vertex to fragment shader
            {
               //TEXCOORDs are just channels go through where you want to deliver 
                //float2 uv : TEXCOORD0; 
                float4 vertex : SV_POSITION;// clip space position
                float3 normal : TEXCOORD0; //it's just an input texcoord doesn't matter here
                float2 uv : TEXCOORD1;
            };

            

            InterPolators vert (MeshData v) //do most things here
            {
                InterPolators o; 
                o.vertex = UnityObjectToClipPos(v.vertex); // local space to clip space
                o.normal = UnityObjectToWorldNormal(v.normals); //just pass through data from vertex
                o.uv = v.uv0;  //(v.uv0 + _Offset) * _Scale;
                return o;
            }

            
            //int 
            // bool 0 1
            // float (32 bit float)
            // half (16 bit float)
            // fixed (lower precision) -1 to 1
            // float4 -> half4 -> fixed4

            float InverseLerp(float a,float b, float v)
            {
                return (v-a)/(b-a);
            }

            
            float4 frag (InterPolators i) : SV_Target //output target
            {
               //float t = saturate( InverseLerp(_ColorStart, _ColorEnd, i.uv.x) );

               //float4 outColor = lerp(_ColorA,_ColorB,t);
                  
               //return outColor;

               //return float4(i.normal,0);

              
               float xOffset = cos(i.uv.x * TAU * 2) * 0.1;
              
               float t = cos((i.uv.y + xOffset -  _Time.y * 0.5 ) * TAU * 5) * 0.5 + 0.1;
              
               // to make fade in and out
               t *= 1 - i.uv.y;
               
               return t;
            }

            ENDCG
        }
    }
}
