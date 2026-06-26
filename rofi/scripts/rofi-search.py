#!/usr/bin/env python3
import sys
import urllib.request
import urllib.parse
from html.parser import HTMLParser
import subprocess
import os

def scrape_ddg_lite(query):
    url = "https://lite.duckduckgo.com/lite/"
    data = urllib.parse.urlencode({'q': query}).encode('utf-8')
    req = urllib.request.Request(url, data=data, headers={'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)'})
    try:
        html = urllib.request.urlopen(req, timeout=5).read().decode('utf-8')
        
        class DDGParser(HTMLParser):
            def __init__(self):
                super().__init__()
                self.results = []
                self.in_result_title = False
                self.current_url = ""
                self.current_title = ""

            def handle_starttag(self, tag, attrs):
                if tag == "a":
                    attrs_dict = dict(attrs)
                    if "class" in attrs_dict and "result-link" in attrs_dict["class"]:
                        self.current_url = attrs_dict.get("href", "")
                        self.in_result_title = True
                        self.current_title = ""

            def handle_data(self, data):
                if self.in_result_title:
                    self.current_title += data

            def handle_endtag(self, tag):
                if tag == "a" and self.in_result_title:
                    self.in_result_title = False
                    if self.current_title.strip():
                        self.results.append((self.current_title.strip(), self.current_url))

        parser = DDGParser()
        parser.feed(html)
        return parser.results
    except Exception as e:
        return [("Error fetching results: " + str(e), "")]

def main():
    if len(sys.argv) > 1:
        query = sys.argv[1]
        
        info = os.environ.get("ROFI_INFO")
        if info and info != "IGNORE":
            subprocess.Popen(["xdg-open", info], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
            return
        elif info == "IGNORE":
            print("\0prompt\x1fSearch\n")
            print("Type a query and press Enter to search...\0info\x1fIGNORE")
            return

        results = scrape_ddg_lite(query)
        if not results:
            print("No results found.\0info\x1fIGNORE")
            return
            
        print("\0prompt\x1fResults\n")
        for title, url in results:
            clean_title = title.replace('\n', ' ').replace('\0', '').strip()
            # Ensure proper format for rofi with hidden info
            print(f"{clean_title}\0info\x1f{url}")
    else:
        print("\0prompt\x1fSearch\n")
        print("Type a query and press Enter to search...\0info\x1fIGNORE")

if __name__ == "__main__":
    main()
