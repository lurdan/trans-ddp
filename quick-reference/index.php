<?php
        // Taken from phplib  (GPL) with trivial hack

	// This function eliminates white space and reduces language codes to the
	// first two letters; effectively eliminating dialect code variants like
	// en-US, en-UK, or es-AR, es-ES, to just en or es. This function should be 
	// called with the built in function array_walk().  This function will change 
	// data in the array.  The function is called like this:
	// array_walk($some_array, "cleanup_language_array")
	function cleanup_language_array(&$pref_lang, $key_not_used) {
			$pref_lang = strtolower( trim($pref_lang) );
			if( ($length = strlen($pref_lang)) > 2 ) 
				$pref_lang = substr($pref_lang, 0, 2);
	}

	// This function will check whether a language is supported.  To add another
	// supported language simply add the two letter code to the avail_lang array.
	// This function will change data in the array and write "0" in place of 
	// unsupported languages.  This function should be called with array_walk().
	// array_walk($some_array, "check_availabilty")
	function check_availabilty(&$pref_lang, $key_not_used) {
		$avail_lang = array ("en", "fr", "it"); 
		$avail_lang_count = count($avail_lang);

		for($i=0; $i < $avail_lang_count; $i++) {
			if( $pref_lang == $avail_lang[$i] ) {
				$is_avail = true;
				break;
			}
		}
		if($is_avail != true)
			$pref_lang = "0";
	}

	$language_preferences = explode( ",", $HTTP_ACCEPT_LANGUAGE);
	if(empty($language_preferences[0])) {
		$LANGUAGE = "en";
		include "index.en.html";
		exit;
	}
	$language_preferences_count = count($language_preferences);


	// This modifies the array $language_preferences
	array_walk($language_preferences, "cleanup_language_array");


	// This modifies the array $language_preferences
	array_walk($language_preferences, "check_availabilty");


	for($i = 0; $i < $language_preferences_count; $i++) 
		if($language_preferences[$i]) {
			$LANGUAGE = $language_preferences[$i];
			include "index.$language_preferences[$i].html";
			exit;
		}
	/*
	 * After this point, you can grab the selected language code with
	 * the variable $LANGUAGE. 
	 */

	// Shouldn't get here. But just in case we don't support what they
	// want.
	 $LANGUAGE = "en";
	 include "index.en.html";
?>
