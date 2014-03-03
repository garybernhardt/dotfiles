#!/bin/bash
#
# From http://wcm1.web.rice.edu/mutt-tips.html

MESSAGE=$(cat)

#NEWALIAS=$(echo "${MESSAGE}" | grep -m 1 ^"From: " | sed s/[\,\"\']//g | awk '{$1=""; if (NF == 3) {print "alias" $0;} else if (NF == 2) {print "alias" $0 $0;} else if (NF > 3) {print "alias", tolower($(NF-1))"-"tolower($2) $0;}}')
make_new_alias() {
    echo "${MESSAGE}" | grep -m 1 ^"From: " | sed s/[\,\"\']//g | awk '{$1=""; if (NF == 3) {print "alias" $0;} else if (NF == 2) {print "alias" $0 $0;} else if (NF > 3) {print "alias", tolower($(NF-1))"-"tolower($2) $0;}}'
}
NEWALIAS=$(make_new_alias)

if grep -q 'notification\|noreply\|no-reply\|\(^bugs@\)' <(echo "$NEWALIAS"); then
    # This is an automated message.
    :
else
    if grep -Fxq "$NEWALIAS" $HOME/.mutt/aliases; then
        # This alias already exists.
        :
    else
        # Create the new alias.
        echo "$NEWALIAS" >> $HOME/.mutt/aliases
    fi
fi

echo "${MESSAGE}"
