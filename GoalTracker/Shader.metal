//
//  Shader.metal
//  GoalTracker
//
//  Created by AJ on 2025/09/22.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>

using namespace metal;

[[stitchable]] half4 liquidGlass(float2 position, half4 color, float isDragging, texture2d<half, access::sample> source_texture) {
    // The sampler defines how to read from the texture
    constexpr sampler s(address::clamp_to_edge, filter::linear);

    // Only apply the distortion when dragging
    if (isDragging > 0.5) {
        // Create a wobble/distortion effect based on position
        float distortion = sin(position.y * 0.2) * 10.0;
        
        // Sample the background at a slightly distorted position
        float2 distorted_pos = position + float2(distortion, 0.0);
        
        // Add chromatic aberration by sampling color channels at different offsets
        half r = source_texture.sample(s, distorted_pos + float2(2.0, 0.0)).r;
        half g = source_texture.sample(s, distorted_pos).g;
        half b = source_texture.sample(s, distorted_pos - float2(2.0, 0.0)).b;
        
        // Combine the channels with the original color for a blended glass effect
        return half4(r, g, b, 0.8) * color;
    }
    
    // When not dragging, return a simple material color
    return color;
}
