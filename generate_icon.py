#!/usr/bin/env python3
"""
Generate a high-resolution macOS app icon for myMindMap.
Creates an Apple-style icon similar to the News app icon.
"""

from PIL import Image, ImageDraw
import os

def create_rounded_rectangle(size, radius):
    """Create a rounded rectangle mask."""
    img = Image.new('L', size, 0)
    draw = ImageDraw.Draw(img)
    draw.rounded_rectangle([0, 0, size[0], size[1]], radius=radius, fill=255)
    return img

def create_app_icon():
    # Standard macOS icon sizes with scale
    icon_sizes = [
        (16, 1), (16, 2),   # 16pt @1x, @2x = 16px, 32px
        (32, 1), (32, 2),   # 32pt @1x, @2x = 32px, 64px
        (128, 1), (128, 2), # 128pt @1x, @2x = 128px, 256px
        (256, 1), (256, 2), # 256pt @1x, @2x = 256px, 512px
        (512, 1), (512, 2), # 512pt @1x, @2x = 512px, 1024px
    ]

    # Base color - deep blue gradient (similar to News app)
    base_color = (65, 105, 225)  # Royal blue

    # Output directory
    output_dir = "Resources/Assets.xcassets/AppIcon.appiconset"
    os.makedirs(output_dir, exist_ok=True)

    for pt_size, scale in icon_sizes:
        size = pt_size * scale

        # Create image with alpha channel
        img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
        draw = ImageDraw.Draw(img)

        # Calculate dimensions
        radius = int(size * 0.22)  # Rounded corners radius

        # Background gradient effect - darker at bottom
        for i in range(size):
            ratio = i / size
            r = int(base_color[0] * (1 - ratio * 0.3))
            g = int(base_color[1] * (1 - ratio * 0.2))
            b = int(base_color[2] * (1 - ratio * 0.1))
            draw.line([(0, i), (size, i)], fill=(r, g, b, 255))

        # Draw stylized mind map icon - nodes connected like a neural network
        center_x = size // 2
        center_y = size // 2

        # Main circle (brain/mind center) - larger, white
        main_radius = int(size * 0.18)
        draw.ellipse([
            center_x - main_radius,
            center_y - main_radius,
            center_x + main_radius,
            center_y + main_radius
        ], fill=(255, 255, 255, 240))

        # Surrounding nodes (like a neural network)
        node_radius = max(2, int(size * 0.04))
        node_positions = [
            # Top ring
            (center_x, center_y - int(size * 0.28)),
            (center_x - int(size * 0.2), center_y - int(size * 0.2)),
            (center_x + int(size * 0.2), center_y - int(size * 0.2)),
            # Middle ring
            (center_x - int(size * 0.32), center_y),
            (center_x + int(size * 0.32), center_y),
            # Bottom ring
            (center_x - int(size * 0.2), center_y + int(size * 0.2)),
            (center_x + int(size * 0.2), center_y + int(size * 0.2)),
            (center_x, center_y + int(size * 0.28)),
        ]

        for nx, ny in node_positions:
            draw.ellipse([
                nx - node_radius,
                ny - node_radius,
                nx + node_radius,
                ny + node_radius
            ], fill=(255, 255, 255, 230))

        # Draw connecting lines between nodes
        line_color = (255, 255, 255, 180)
        line_width = max(1, int(size * 0.015))

        # Connect center to outer nodes
        connections = [
            # From center
            ((center_x, center_y), (center_x, center_y - int(size * 0.28))),
            ((center_x, center_y), (center_x - int(size * 0.2), center_y - int(size * 0.2))),
            ((center_x, center_y), (center_x + int(size * 0.2), center_y - int(size * 0.2))),
            ((center_x, center_y), (center_x - int(size * 0.32), center_y)),
            ((center_x, center_y), (center_x + int(size * 0.32), center_y)),
            ((center_x, center_y), (center_x - int(size * 0.2), center_y + int(size * 0.2))),
            ((center_x, center_y), (center_x + int(size * 0.2), center_y + int(size * 0.2))),
            ((center_x, center_y), (center_x, center_y + int(size * 0.28))),
            # Connect outer nodes
            ((center_x, center_y - int(size * 0.28)), (center_x - int(size * 0.2), center_y - int(size * 0.2))),
            ((center_x, center_y - int(size * 0.28)), (center_x + int(size * 0.2), center_y - int(size * 0.2))),
            ((center_x - int(size * 0.32), center_y), (center_x - int(size * 0.2), center_y + int(size * 0.2))),
            ((center_x + int(size * 0.32), center_y), (center_x + int(size * 0.2), center_y + int(size * 0.2))),
        ]

        for (x1, y1), (x2, y2) in connections:
            draw.line([(x1, y1), (x2, y2)], fill=line_color, width=line_width)

        # Add subtle highlight at top
        highlight_height = int(size * 0.15)
        for i in range(highlight_height):
            alpha = int(60 * (1 - i / highlight_height))
            draw.line([(radius, i), (size - radius, i)], fill=(255, 255, 255, alpha))

        # Apply rounded corners mask
        mask = create_rounded_rectangle((size, size), radius)
        img.putalpha(mask)

        # Save with proper filename format
        filename = f"icon_{pt_size}x{pt_size}@{scale}x.png"
        filepath = os.path.join(output_dir, filename)
        img.save(filepath, 'PNG')
        print(f"Created {filepath}")

    print("App icon generation complete!")

if __name__ == "__main__":
    create_app_icon()
