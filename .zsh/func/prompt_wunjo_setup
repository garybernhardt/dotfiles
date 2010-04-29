# wunjo prompt theme

autoload -U zgitinit
zgitinit

prompt_wunjo_help () {
  cat <<'EOF'

  prompt wunjo

EOF
}

revstring() {
	git describe --always $1 2>/dev/null ||
	git rev-parse --short $1 2>/dev/null
}

coloratom() {
	local off=$1 atom=$2
	if [[ $atom[1] == [[:upper:]] ]]; then
		off=$(( $off + 60 ))
	fi
	echo $(( $off + $colorcode[${(L)atom}] ))
}
colorword() {
	local fg=$1 bg=$2 att=$3
	local -a s

	if [ -n "$fg" ]; then
		s+=$(coloratom 30 $fg)
	fi
	if [ -n "$bg" ]; then
		s+=$(coloratom 40 $bg)
	fi
	if [ -n "$att" ]; then
		s+=$attcode[$att]
	fi

	echo "%{"$'\e['${(j:;:)s}m"%}"
}

prompt_wunjo_setup() {
	local verbose
	if [[ $TERM == screen* ]] && [ -n "$STY" ]; then
		verbose=
	else
		verbose=1
	fi

	typeset -A colorcode
	colorcode[black]=0
	colorcode[red]=1
	colorcode[green]=2
	colorcode[yellow]=3
	colorcode[blue]=4
	colorcode[magenta]=5
	colorcode[cyan]=6
	colorcode[white]=7
	colorcode[default]=9
	colorcode[k]=$colorcode[black]
	colorcode[r]=$colorcode[red]
	colorcode[g]=$colorcode[green]
	colorcode[y]=$colorcode[yellow]
	colorcode[b]=$colorcode[blue]
	colorcode[m]=$colorcode[magenta]
	colorcode[c]=$colorcode[cyan]
	colorcode[w]=$colorcode[white]
	colorcode[.]=$colorcode[default]

	typeset -A attcode
	attcode[none]=00
	attcode[bold]=01
	attcode[faint]=02
	attcode[standout]=03
	attcode[underline]=04
	attcode[blink]=05
	attcode[reverse]=07
	attcode[conceal]=08
	attcode[normal]=22
	attcode[no-standout]=23
	attcode[no-underline]=24
	attcode[no-blink]=25
	attcode[no-reverse]=27
	attcode[no-conceal]=28

	local -A pc
	pc[default]='default'
	pc[date]='cyan'
	pc[time]='Blue'
	pc[host]='Green'
	pc[user]='cyan'
	pc[punc]='yellow'
	pc[line]='magenta'
	pc[hist]='green'
	pc[path]='Cyan'
	pc[shortpath]='default'
	pc[rc]='red'
	pc[scm_branch]='Cyan'
	pc[scm_commitid]='Yellow'
	pc[scm_status_dirty]='Red'
	pc[scm_status_staged]='Green'
	pc[#]='Yellow'
	for cn in ${(k)pc}; do
		pc[${cn}]=$(colorword $pc[$cn])
	done
	pc[reset]=$(colorword . . 00)

	typeset -Ag wunjo_prompt_colors
	wunjo_prompt_colors=(${(kv)pc})

	local p_date p_line p_rc

	p_date="$pc[date]%D{%Y-%m-%d} $pc[time]%D{%T}$pc[reset]"

	p_line="$pc[line]%y$pc[reset]"

	PROMPT=
	if [ $verbose ]; then
		PROMPT+="$pc[host]%m$pc[reset] "
	fi
	PROMPT+="$pc[path]%(2~.%~.%/)$pc[reset]"
	PROMPT+="\$(prompt_wunjo_scm_status)"
	PROMPT+="%(?.. $pc[rc]exited %1v$pc[reset])"
	PROMPT+="
"
	PROMPT+="$pc[hist]%h$pc[reset] "
	PROMPT+="$pc[shortpath]%1~$pc[reset]"
	PROMPT+="\$(prompt_wunjo_scm_branch)"
	PROMPT+=" $pc[#]%#$pc[reset] "

	RPROMPT=
	if [ $verbose ]; then
		RPROMPT+="$p_date "
	fi
	RPROMPT+="$pc[user]%n$pc[reset]"
	RPROMPT+=" $p_line"

	export PROMPT RPROMPT
	precmd_functions+='prompt_wunjo_precmd'
}

prompt_wunjo_precmd() {
	local ex=$?
	psvar=()

	if [[ $ex -ge 128 ]]; then
		sig=$signals[$ex-127]
		psvar[1]="sig${(L)sig}"
	else
		psvar[1]="$ex"
	fi
}

prompt_wunjo_scm_status() {
	zgit_isgit || return
	local -A pc
	pc=(${(kv)wunjo_prompt_colors})

	head=$(zgit_head)
	gitcommit=$(revstring $head)

	local -a commits

	if zgit_rebaseinfo; then
		orig_commit=$(revstring $zgit_info[rb_head])
		orig_name=$(git name-rev --name-only $zgit_info[rb_head])
		orig="$pc[scm_branch]$orig_name$pc[punc]($pc[scm_commitid]$orig_commit$pc[punc])"
		onto_commit=$(revstring $zgit_info[rb_onto])
		onto_name=$(git name-rev --name-only $zgit_info[rb_onto])
		onto="$pc[scm_branch]$onto_name$pc[punc]($pc[scm_commitid]$onto_commit$pc[punc])"

		if [ -n "$zgit_info[rb_upstream]" ] && [ $zgit_info[rb_upstream] != $zgit_info[rb_onto] ]; then
			upstream_commit=$(revstring $zgit_info[rb_upstream])
			upstream_name=$(git name-rev --name-only $zgit_info[rb_upstream])
			upstream="$pc[scm_branch]$upstream_name$pc[punc]($pc[scm_commitid]$upstream_commit$pc[punc])"
			commits+="rebasing $upstream$pc[reset]..$orig$pc[reset] onto $onto$pc[reset]"
		else
			commits+="rebasing $onto$pc[reset]..$orig$pc[reset]"
		fi

		local -a revs
		revs=($(git rev-list $zgit_info[rb_onto]..HEAD))
		if [ $#revs -gt 0 ]; then
			commits+="\n$#revs commits in"
		fi

		if [ -f $zgit_info[dotest]/message ]; then
			mess=$(head -n1 $zgit_info[dotest]/message)
			commits+="on $mess"
		fi
	elif [ -n "$gitcommit" ]; then
		commits+="on $pc[scm_branch]$head$pc[punc]($pc[scm_commitid]$gitcommit$pc[punc])$pc[reset]"
		local track_merge=$(zgit_tracking_merge)
		if [ -n "$track_merge" ]; then
			if git rev-parse --verify -q $track_merge >/dev/null; then
				local track_remote=$(zgit_tracking_remote)
				local tracked=$(revstring $track_merge 2>/dev/null)

				local -a revs
				revs=($(git rev-list --reverse $track_merge..HEAD))
				if [ $#revs -gt 0 ]; then
					local base=$(revstring $revs[1]~1)
					local base_name=$(git name-rev --name-only $base)
					local base_short=$(revstring $base)
					local word_commits
					if [ $#revs -gt 1 ]; then
						word_commits='commits'
					else
						word_commits='commit'
					fi

					local conj="since"
					if [[ "$base" == "$tracked" ]]; then
						conj+=" tracked"
						tracked=
					fi
					commits+="$#revs $word_commits $conj $pc[scm_branch]$base_name$pc[punc]($pc[scm_commitid]$base_short$pc[punc])$pc[reset]"
				fi

				if [ -n "$tracked" ]; then
					local track_name=$track_merge
					if [[ $track_remote == "." ]]; then
						track_name=${track_name##*/}
					fi
					tracked=$(revstring $tracked)
					commits+="tracking $pc[scm_branch]$track_name$pc[punc]"
					if [[ "$tracked" != "$gitcommit" ]]; then
						commits[$#commits]+="($pc[scm_commitid]$tracked$pc[punc])"
					fi
					commits[$#commits]+="$pc[reset]"
				fi
			fi
		fi
	fi

	gitsvn=$(git rev-parse --verify -q --short git-svn)
	if [ $? -eq 0 ]; then
		gitsvnrev=$(zgit_svnhead $gitsvn)
		gitsvn=$(revstring $gitsvn)
		if [ -n "$gitsvnrev" ]; then
			local svninfo=''
			local -a revs
			svninfo+="$pc[default]svn$pc[punc]:$pc[scm_branch]r$gitsvnrev"
			revs=($(git rev-list git-svn..HEAD))
			if [ $#revs -gt 0 ]; then
				svninfo+="$pc[punc]@$pc[default]HEAD~$#revs"
				svninfo+="$pc[punc]($pc[scm_commitid]$gitsvn$pc[punc])"
			fi
			commits+=$svninfo
		fi
	fi

	if [ $#commits -gt 0 ]; then
		echo -n " ${(j: :)commits}"
	fi
}

prompt_wunjo_scm_branch() {
	zgit_isgit || return
	local -A pc
	pc=(${(kv)wunjo_prompt_colors})

	echo -n "$pc[punc]:$pc[scm_branch]$(zgit_head)"

	if zgit_inworktree; then
		if ! zgit_isindexclean; then
			echo -n "$pc[scm_status_staged]+"
		fi

		local -a dirty
		if ! zgit_isworktreeclean; then
			dirty+='!'
		fi

		if zgit_hasunmerged; then
			dirty+='*'
		fi

		if zgit_hasuntracked; then
			dirty+='?'
		fi

		if [ $#dirty -gt 0 ]; then
			echo -n "$pc[scm_status_dirty]${(j::)dirty}"
		fi
	fi

	echo $pc[reset]
}

prompt_wunjo_setup "$@"

# vim:set ft=zsh:
