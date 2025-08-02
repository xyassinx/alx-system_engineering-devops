#!/bin/bash

for x in *;
do
	if [[ -f "$x" && "$x" != *.* ]];
	then
		echo '#!/bin/bash' > "$x"
		chmod +x "$x"
	fi
done
