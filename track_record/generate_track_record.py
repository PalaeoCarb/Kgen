import numpy,json,subprocess,os,sys,re,datetime
from matplotlib import pyplot

# Use the version of Kgen currently in the python directory
sys.path.append('./python')
import kgen

def get_git_revision_hash():
    # Returns a string which is the current head SHA
    return subprocess.check_output(['git', 'rev-parse', 'HEAD']).decode('ascii').strip()

# Palaeo seawater far from modern is the worst case scenario so we'll target that
temperature = 40 # degrees C
salinity = 30 # unitless (or psu if you like)
pressure  = 5000/10 # bar (~depth/10)
calcium = 40/1e3 # mol/kg ((mmol/kg)/1000)
magnesium = 20/1e3 # mol/kg ((mmol/kg)/1000)

# Do the calculation using Kgen
Ks_calculated = kgen.calc_Ks(temp_c=temperature,sal=salinity,p_bar=pressure,magnesium=magnesium,calcium=calcium)

# Load the track record
# Or make a new one - most of the time this will be irrelevant but just in case we restart the track record
if os.path.isfile("./track_record/K_track_record.json"):
    with open("./track_record/K_track_record.json","r") as file:
        K_track_record = json.loads(file.read())
else:
    K_track_record = {}

# Add the current results to the track record
hash = get_git_revision_hash()
K_track_record[hash] = {"datetime":datetime.datetime.now().strftime("%Y/%m/%d %H:%M:%S"),
                        "Ks":Ks_calculated}

# Save the results back to the JSON file
with open("./track_record/K_track_record.json","w") as file:
    file.write(json.dumps(K_track_record,indent=4))

# Sort the commits
commits = [{"sha":commit[0],"datetime":datetime.datetime.strptime(commit[1]["datetime"],"%Y/%m/%d %H:%M:%S")} for commit in K_track_record.items()]
datetimes = [commit["datetime"] for commit in commits]
indices = numpy.arange(0,len(datetimes))
sort_indices = numpy.argsort(datetimes)

# Extract the most recent three and first one for comparison (or all of them if there aren't four commits yet)
if len(sort_indices)>4:
    collect = [sort_indices[0]]+list(sort_indices[-3:])
    shas = [commits[index]["sha"] for index in collect]
else:
    shas = [commits[index]["sha"] for index in sort_indices]

# Use the current one as the comparator
normaliser = K_track_record[shas[-1]]

# Iterate to quantify the difference as a percentage
K_differences = []
for sha in shas:
    current_K_difference = {}
    for K in normaliser["Ks"].keys():
        current_K_difference[K] = ((K_track_record[sha]["Ks"][K]-normaliser["Ks"][K])/normaliser["Ks"][K])*100.0
    K_differences += [list(current_K_difference.values())]

# Generate a figure
figure,axes = pyplot.subplots(nrows=1)
axes = [axes]

short_shas = [sha[0:8] for sha in shas]
k_names = ["K$_{0}^{*}$","K$_{1}^{*}$","K$_{2}^{*}$","K$_{W}^{*}$","K$_{B}^{*}$","K$_{S}^{*}$","K$_{spA}^{*}$","K$_{spC}^{*}$","K$_{P1}^{*}$","K$_{P2}^{*}$","K$_{P3}^{*}$","K$_{Si}^{*}$","K$_{F}^{*}$"]

for K_difference,sha in zip(K_differences,short_shas,strict=True):
    axes[0].plot(numpy.arange(0,len(normaliser["Ks"])),K_difference,marker="o",label=sha)


axes[0].set_xlim((0,len(normaliser["Ks"])-1))
axes[0].set_xticks(numpy.arange(0,len(normaliser["Ks"])))
axes[0].set_xticklabels(k_names)
# axes[0].set_xlabel("K*")
axes[0].set_ylabel("Difference (%)")

pyplot.legend()

figure.savefig("./track_record/recent.png")


