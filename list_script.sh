echo "=== Dossiers AVEC .bam ==="
for d in */; do
    if compgen -G "$d*.bam" > /dev/null; then
        echo "  $d"
    fi
done

echo
echo "=== Dossiers SANS .bam ==="
for d in */; do
    if ! compgen -G "$d*.bam" > /dev/null; then
        echo "  $d"
    fi
done



#path samtools 
export PATH=/pbs/home/f/fblanchard/samtools-1.20:$PATH


# liste des version de dorado utilisé 

for bam in */*.bam; do
    dir="${bam%%/*}"  
    val=$(samtools view "$bam" 2>/dev/null | head -n 1 | awk '{print $NF}' | sed 's/^[^@]*@//')
    printf "%s\t%s\n" "$dir" "$val"
done



echo "=== Versions v5 ==="
for bam in */*.bam; do
    dir="${bam%%/*}"
    val=$(samtools view "$bam" 2>/dev/null | head -n 1 | awk '{print $NF}' | sed 's/^[^@]*@//')

    if [[ $val == v5* ]]; then
        printf "%s\t%s\n" "$dir" "$val"
    fi
done





echo "=== Autres versions ==="
for bam in */*.bam; do
    dir="${bam%%/*}"
    val=$(samtools view "$bam" 2>/dev/null | head -n 1 | awk '{print $NF}' | sed 's/^[^@]*@//')

    if [[ $val != v5* ]]; then
        printf "%s\t%s\n" "$dir" "$val"
    fi
done





/pbs/home/l/lefebure/src/dorado-1.2.0-linux-x64/bin/dorado



#elements dans liste 1 et pas dans liste 2

grep -F -x -v -f liste2.txt liste1.txt


#elements en commun entre les lists 

grep -F -x -f liste1.txt liste2.txt
