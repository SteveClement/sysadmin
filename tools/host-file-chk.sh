insert into hosts values (0,"","","","","");
MACHINAS="xenon kierbiischt dubnium oberon zinc belion snoopy.party.lu terbium nasion headquarter pppoe56-luxdsl-033.pt.lu pppoe58-luxdsl-179.pt.lu vodsl-1624.vo.lu pppoe233-luxdsl-178.pt.lu pppoe227-luxdsl-076.pt.lu"

for a in `echo $MACHINAS`; do
echo $a
ssh $a "rootdo locate portchk.sh"
done
