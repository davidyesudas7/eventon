import json
import urllib.request
import os
import re

input_file = r"C:\Users\aseer\.gemini\antigravity-ide\brain\a1821e3a-a6ea-4c2e-9696-5360da383202\.system_generated\steps\5\output.txt"
output_dir = r"C:\Users\aseer\Desktop\flutter projects\eventon\stitch_downloads"

os.makedirs(output_dir, exist_ok=True)

with open(input_file, 'r', encoding='utf-8') as f:
    content = f.read()

# find the JSON part
json_match = re.search(r'{"screens":\[.*\]}', content, re.DOTALL)
if json_match:
    json_str = json_match.group(0)
    data = json.loads(json_str)
    
    for screen in data.get('screens', []):
        title = screen.get('title', 'Untitled')
        safe_title = re.sub(r'[\\/*?:"<>|]', "", title).strip()
        safe_title = safe_title.replace(' ', '_')
        
        screenshot = screen.get('screenshot', {})
        html_code = screen.get('htmlCode', {})
        
        print(f"Processing: {title}")
        
        if screenshot and screenshot.get('downloadUrl'):
            url = screenshot['downloadUrl']
            filepath = os.path.join(output_dir, f"{safe_title}.png")
            print(f"Downloading image: {filepath}")
            try:
                urllib.request.urlretrieve(url, filepath)
            except Exception as e:
                print(f"Error downloading {url}: {e}")
                
        if html_code and html_code.get('downloadUrl'):
            url = html_code['downloadUrl']
            ext = ".html"
            if html_code.get('mimeType') == 'text/markdown':
                ext = ".md"
            filepath = os.path.join(output_dir, f"{safe_title}{ext}")
            print(f"Downloading code: {filepath}")
            try:
                urllib.request.urlretrieve(url, filepath)
            except Exception as e:
                print(f"Error downloading {url}: {e}")
else:
    print("Could not find JSON in output file")
