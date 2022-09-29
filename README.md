# Google Dorks Grabber

> The OSINT project, the main idea of which is to collect all the possible Google dorks search combinations and to find the information about the specific web-site: common admin panels, the widespread file types and path traversal. The 100% automated.
>

Usage Example:
--------------

> ```bash
> chmod +x google-dorks-grabber.sh
> 
> ./google-dorks-grabber.sh testphp.vulnweb.com
> ```
>
> OR
>
> ```bash
> bash ./google-dorks-grabber.sh testphp.vulnweb.com
> ```
>
> This will work beautifully on Kali but an ultimately universal way is through Docker. Just run
>
> ```bash
> docker build -t GDG .
> ```
>
> and then run it with your argument for the URL such as this:
>
> ```bash
> docker run -it --rm GDG testphp.vulnweb.com
> ```
