#!/usr/bin/python3
import yt_dlp
import glob
import os
import sys
import random

#change $HOME to actual path
os.chdir("$HOME/Downloads/twitch-downloads")


def check_args():
    if len(sys.argv) < 3:
        print(
            "\nThis Script requires 3 arguments\n1.Twitch url\n2.Start time (HH.MM)\n3.End time (HH.MM)\n"
        )
        sys.exit()


def check_ts():
    ts_files = glob.glob("*.ts")
    txt_file = glob.glob("*.txt")
    txt_file += glob.glob("wget*")
    if txt_file:
        for i in txt_file:
            os.remove(i)
    if ts_files:
        dek = input(
            """Files from last download still in folder
Delete (Press y to delete ) : """
        )
        if dek == "y":
            for i in ts_files:
                os.remove(i)
        else:
            return
    else:
        return


def randend():
    result_str = "".join(
        (random.choice("abcdefghijklmnopqrstuvwxyz2#$(&^*1234569780") for i in range(4))
    )
    return result_str


def p_format(url):
    URL = url
    ydl_opts = {"quiet": "True"}
    no = 1
    with yt_dlp.YoutubeDL(ydl_opts) as ydl:
        info = ydl.extract_info(URL, download=False)

    print(
        "            "
        + str(info["title"])
        + " | "
        + str(info["uploader"])
        + "\n"
        + str(info["chapters"])
    )
    print("     RESOLUTION             PROTOCOL          VCODEC           ACODEC")
    for i in range(0, 7):
        if (
            info["formats"][i]["format_id"] != "Audio_Only"
            and info["formats"][i]["protocol"] != "mhtml"
        ):
            print(
                no,
                ")",
                str(info["formats"][i]["format"]),
                "     ",
                str(info["formats"][i]["protocol"]),
                "     ",
                str(info["formats"][i]["vcodec"]),
                "    ",
                str(info["formats"][i]["acodec"]),
            )
            no += 1
    return info


def get_url(udic, op):
    URL = None
    info = udic
    res_opts = op
    try:
        for i in range(0, 8):
            if res_opts in info["formats"][i]["url"]:
                URL = info["formats"][i]["url"]
        return URL
    except Exception as e:
        print(e)


def get_lnks(lnk, t1, t2):
    url = lnk.split("index")[0]
    newlnks = []
    for i in range(t1, t2 + 1):
        newlnks += [f"{url}{t1}.ts"]
        t1 += 1
    return newlnks


def get_time(tim1):
    if tim1 == "0":
        return int(1)
    if "." in tim1:
        st1 = int(tim1.split(".")[0])
        st2 = int(tim1.split(".")[1])
        #print(f"{st1, st2}")
        return int(f"{st1*360+st2*6}")
    else:
        #print(f"{st1, st2}")
        st1 = int(tim1)
        st2 = 0
        return int(f"{st1*360+st2*6}")


def get_input():
    choice = (None, "/160p", "/360p", "/480p", "/720p")
    while True:
        ans = 0
        try:
            ans = int(input("Enter Option (1,2,3,4): "))
            if ans not in (1, 2, 3, 4):
                raise ValueError
            else:
                return str(choice[ans])
        except ValueError:
            print("FALSE INPUT TRY AGAIN")


def download_url(urls, t1, t2):
    init_c = 0
    tot_c = t2 - t1
    print("Downloading Ts Files  \n")
    try:
        for lnk in urls:
        #T-timeout t - retries --read-timeout - timeout till no activity
            os.system(f'wget -c -4 -q -nc -T 10 --retry-connrefused --read-timeout=5 -t 30"{lnk}" >/dev/null 2>&1')
            update_progress(init_c, tot_c)
            init_c += 1
    except KeyboardInterrupt:
        print("\n\n\n***INTERUPPTED***\nPROGRAM EXITING ....\n")


def make_vid():
    DFOLDER = os.getcwd()
    #change to $HOME to actual path
    SAVEFOLDER = "$HOME/Desktop"
    exten = ".ts"
    files = glob.glob1(DFOLDER, "*" + exten)
    nfiles = sorted(files, key=lambda x: int(x.split(".")[0]))
    rand1 = str(randend())
    t2 = sys.argv[3]
    print("Combining Ts Files  \n")
    for f in nfiles:
        with open(file=f, mode="rb") as f:
            content = f.read()
        with open(file=f"{SAVEFOLDER}/Twi{rand1}({t2}).mp4", mode="ab") as fp:
            fp.write(content)


def update_progress(current_value, total):
    increments = 50
    percentual = int(((current_value / total) * 100))
    i = int(percentual * (increments / 100))
    text = "\r[{0: <{1}}] {2}/{3} ({4}%)".format(
        "#" * i, increments, current_value, total, percentual
    )
    print(text, end="\n" if percentual == 100 else "")


def main():
    try:
        check_args()
        check_ts()
        m3u_lnk = p_format(sys.argv[1])
        res_opts = str(get_input())
        t1 = get_time(sys.argv[2])
        t2 = get_time(sys.argv[3])
        lnk = get_url(m3u_lnk, res_opts)
        urls = get_lnks(lnk, t1, t2)
        download_url(urls, t1, t2)
        print("Checking File Integrity  \n")
        os.system("find ./ -type f -size 0 -delete")
        download_url(urls, t1, t2)
        make_vid()
    except KeyboardInterrupt:
        print("\n\n\n***INTERUPPTED***\nPROGRAM EXITING ....\n")


if __name__ == "__main__":
    main()


"""
def old_download_url(url):
	new_name = url.split('/')[-1]
	content_size = int(requests.get(url, stream=True).headers['Content-Length'])
	if os.path.exists(new_name):
		if content_size == os.path.getsize(new_name):
			return
		temp_size = os.path.getsize(new_name)
	else:
         	temp_size = 0

	headers = {'Range': 'bytes=%d-' % temp_size}
	r = requests.get(url, stream=True, headers=headers)
	if r.ok:
		with open(new_name, 'ab') as file:
			file.write(r.content)
	else:
		print(f'Download of file {new_name} failed!!!')

"""

