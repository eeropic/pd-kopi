# META NAME pd-kopi
# META DESCRIPTION Copy & paste patches as plaintext from & to Pd windows
# META DESCRIPTION Writes and reads a temporary file stored in plugin path
# META AUTHOR Eero Johannes Pitkänen <eero.pitkanen@gmail.com>

package require pd_bindings

namespace eval ::pd-kopi:: {
	proc menu_copy_plaintext {} {
		if { $::focused_window ne ".pdwindow" } {
			set kopi_tmp_name "pdkopi-tmp-clipb"
			set rootWindow $::focused_window
			set tempFileName "${kopi_tmp_name}_"
			set tempDirPath $::current_plugin_loadpath
			set tempFilePath "${tempDirPath}/${tempFileName}.pd"
			pdtk_post "\n pd-kopi tempdirpath: $tempDirPath"
			pdtk_post "\n pd-kopi tempfilename: $tempFileName"
			pdsend "$::focused_window copy"
			pdsend "$::focused_window obj -32760 -32760 pd ${kopi_tmp_name}"
			pdsend "pd-${kopi_tmp_name} paste"
			pdsend "pd-${kopi_tmp_name} savetofile ${tempFileName}.pd $tempDirPath"
			pdsend "pd-${kopi_tmp_name} menuclose"
			pdsend "$::focused_window mouse -32768 -32768 0 0"
			pdsend "$::focused_window mouseup -32000 -32000 0"
			pdsend "$::focused_window cut"
			pdsend "pd open ${tempFileName}.pd ${tempDirPath}"
			pdsend "pd-${kopi_tmp_name} editmode 1"
			pdsend "pd-${kopi_tmp_name} selectall"
			pdsend "pd-${kopi_tmp_name} copy"
			pdsend "pd-${kopi_tmp_name} menuclose"
			after 100
			read_temp_file $tempFilePath
			pdtk_post "\n pd-kopi: Copied to clipboard (plaintext)"
		}
	}
	
	proc read_temp_file { tf } {
		set fp [open $tf r]
		set file_data [read $fp]
		clipboard clear
		clipboard append $file_data
		close $fp
		return $file_data
	}

	proc menu_paste_plaintext {} {
		if { $::focused_window ne ".pdwindow" } {
			set kopi_tmp_name "pdkopi-tmp-clipb"
			set data [clipboard get]
			set tempFileName "${kopi_tmp_name}"
			set tempDirPath $::current_plugin_loadpath
			set tempFilePath "${tempDirPath}/${tempFileName}.pd"
						
			set fileId [open $tempFilePath "w"]
			puts -nonewline $fileId $data
			close $fileId
			
			pdsend "pd open ${tempFileName}.pd ${tempDirPath}"
			pdsend "pd-${kopi_tmp_name} editmode 1"
			pdsend "pd-${kopi_tmp_name} selectall"
			pdsend "pd-${kopi_tmp_name} copy"
			pdsend "pd-${kopi_tmp_name} menuclose"
			pdsend "$::focused_window paste"
			
			pdtk_post "pd-kopi: Pasted from clipboard (plaintext)\n"
		}
	}


	proc init {} {
	
		variable accelerator
		variable alt
		variable modifier
		
		if {$::windowingsystem eq "aqua"} {
			set accelerator "Cmd"
			set alt "Option"
			set modifier "Command"
		} else {
			set accelerator "Ctrl"
			set alt "Alt"
			set modifier "Control"
		}
		
		set mymenu .menubar.edit
		
		$mymenu insert 5 command \
		-accelerator "$accelerator+$alt+c" \
		-label "Copy as Plaintext" \
		-command {::pd-kopi::menu_copy_plaintext}
		
		$mymenu insert 7 command \
		-accelerator "$accelerator+$alt+v" \
		-label "Paste from Plaintext" \
		-command {::pd-kopi::menu_paste_plaintext}			
	}
	
}

::pd-kopi::init
