function upgrade() {
 $sudo pacman -Syu
}

function pacman() {
	case $1 in
		-S | -S[^sih]* | -R* | -U*) $sudo pacman $* ;;
		* ) command pacman $* ;;
	esac
}

function clyde() {
	case $1 in
		-S | -S[^sih]* | -R* | -U*) $sudo clyde $* ;;
		* ) command clyde $* ;;
	esac
}

alias rc.d="$sudo rc.d"

alias pacupg="$sudo pacman -Syu"        # Synchronize with repositories before upgrading packages that are out of date on the local system.
alias pacin="$sudo pacman -S"           # Install specific package(s) from the repositories
alias pacins="$sudo pacman -U"          # Install specific package not from the repositories but from a file 
alias pacre="$sudo pacman -R"           # Remove the specified package(s), retaining its configuration(s) and required dependencies
alias pacrem="$sudo pacman -Rns"        # Remove the specified package(s), its configuration(s) and unneeded dependencies
alias pacrep="pacman -Si"              # Display information about a given package in the repositories
alias pacreps="pacman -Ss"             # Search for package(s) in the repositories
alias pacloc="pacman -Qi"              # Display information about a given package in the local database
alias paclocs="pacman -Qs"             # Search for package(s) in the local database
# Additional pacman alias examples
if [[ -x `which abs` ]]; then
  alias pacupd="$sudo pacman -Sy && $sudo abs"     # Update and refresh the local package and ABS databases against repositories
else
  alias pacupd="$sudo pacman -Sy"     # Update and refresh the local package and ABS databases against repositories
fi
alias pacinsd="$sudo pacman -S --asdeps"        # Install given package(s) as dependencies of another package
alias pacmir="$sudo pacman -Syy"                # Force refresh of all package lists after updating /etc/pacman.d/mirrorlist

# https://bbs.archlinux.org/viewtopic.php?id=93683
paclist() {
  $sudo pacman -Qei $(pacman -Qu|cut -d" " -f 1)|awk ' BEGIN {FS=":"}/^Name/{printf("\033[1;36m%s\033[1;37m", $2)}/^Description/{print $2}'
}

alias paclsorphans="$sudo pacman -Qdt"
alias pacrmorphans="$sudo pacman -Rs $(pacman -Qtdq)"

pacdisowned() {
  tmp=${TMPDIR-/tmp}/pacman-disowned-$UID-$$
  db=$tmp/db
  fs=$tmp/fs

  mkdir "$tmp"
  trap  'rm -rf "$tmp"' EXIT

  pacman -Qlq | sort -u > "$db"

  find /bin /etc /lib /sbin /usr \
      ! -name lost+found \
        \( -type d -printf '%p/\n' -o -print \) | sort > "$fs"

  comm -23 "$fs" "$db"
}
