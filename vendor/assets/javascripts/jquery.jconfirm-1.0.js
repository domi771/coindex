/**
 * jQuery jConfirm Plugin
 * 
 * Copyright (C) 2013 Simon Emms
 * 
 * jConfirm is a simple plugin to enable
 * you to write styled confirmation boxes
 * that events can be attached to.
 * 
 * This program is free software: you can
 * redistribute it and/or modify it under
 * the terms of the GNU General Public
 * License as published by the Free Software
 * Foundation, either version 3 of the
 * License, or any later version.
 * 
 * This program is distributed in the hope
 * that it will be useful, but WITHOUT ANY
 * WARRANTY; without even the implied warranty
 * of MERCHANTABILITY or FITNESS FOR A
 * PARTICULAR PURPOSE.  See the GNU General
 * Public License for more details.
 * 
 * You should have received a copy of the GNU
 * General Public License along with this
 * program.  If not, see
 * <http://www.gnu.org/licenses/gpl-3.0.txt>.
 * 
 * @author Simon Emms <simon@simonemms.com>
 * @licence GNU GPLv3 <http://www.gnu.org/licenses/gpl-3.0.txt>
 * @version 1.0
 */
(function(jQuery) {

    /* Private methods */
    var objMethods = {
        
        getConfig: {
            cancel: '%cancel%',
            confirm: '%confirm%',
            cancelTrigger: '%cancelTrigger%',
            confirmTrigger: '%confirmTrigger%',
            message: '%message%',
            title: '%title%',
            wrapperId: '%wrapperId%',
            outerWrapperId: '%outerWrapperId%'
        },

        getDefaultTemplate: function() {

            var objConfig = objMethods.getConfig;

            /* Create the template */
            var html = '<div id="'+objConfig.outerWrapperId+'" class="jconfirm_wrapper">';
            html += '<div id="'+objConfig.wrapperId+'" class="jconfirm_inner">';
            html += '<a href="#" class="jconfirm_close">&times;</a>';

            /* Title */
            html += '<h4 class="jconfirm_title">';
            html += objConfig.title;
            html += '</h4>';

            /* Message */
            html += '<div class="jconfirm_message">';
            html += objConfig.message;
            html += '</div>';

            /* Action buttons */
            html += '<div class="jconfirm_buttons">';
            html += '<a href="#" id="'+objConfig.confirmTrigger+'" class="pull-right btn btn-primary">';
            html += objConfig.confirm;
            html += '</a>';
            html += '<a href="#" id="'+objConfig.cancelTrigger+'" style="margin-right: 10px;"class="pull-right btn btn-primary">';
            html += objConfig.cancel;
            html += '</a>';
            html += '</div>';

            html += '</div>';
            html += '</div>';

            return html;
        },
        
        init: function( objConfig, callback ) {
            
            /* Config for height/width/margins */
            var width = jQuery(window).width() / 2;
            if(width > objConfig.maxWidth) { width = objConfig.maxWidth; }
            var margin_left = width / 2;

            if(objConfig.template === null) {
                /* Get the default template */
                objConfig.template = objMethods.getDefaultTemplate();
            }
            
            var timestamp = new Date().getTime();
            objConfig.cancelTrigger = objConfig.cancelTrigger + '_' + timestamp;
            objConfig.confirmTrigger = objConfig.confirmTrigger + '_' + timestamp;
            objConfig.wrapperId = objConfig.wrapperId + '_' + timestamp;
            
            var template = objMethods.parseTemplate(objConfig, timestamp);
            
            /* Attach */
            jQuery('body').append(template);
            
            var height = jQuery('#'+objConfig.wrapperId).height();
            var margin_top = height;
            jQuery('#'+objConfig.wrapperId).css({
                position: 'absolute',
                top: '50%',
                left: '50%',
                'margin-left': 0 - margin_left,
                'margin-top': 0 - (margin_top / 2),
                width: width,
                height: height
            });
            
            /* Attach the events */
            jQuery('body').keydown(function(e) {
                if(e.keyCode === 27) {
                    /* Escape */
                    jQuery('#'+objConfig.cancelTrigger).trigger('click');
                    return false;
                } else if(e.keyCode === 13) {
                    /* Enter */
                    jQuery('#'+objConfig.confirmTrigger).trigger('click');
                    return false;
                } else {
                    /* Any other key */
                    return true;
                }
            });
            
            /** Fail events - just close */
            jQuery('#'+objConfig.cancelTrigger).click(function() {
                jQuery('#'+objConfig.outerWrapperId).remove();
                return false;
            });
            
            jQuery('#'+objConfig.wrapperId).find('.jconfirm_close').click(function() {
                jQuery('#'+objConfig.cancelTrigger).trigger('click');
                return false;
            });
            
            /* Do we close on outer wrapper click? */
            if(objConfig.closeOnOuterWrapperClick) {
                jQuery('#'+objConfig.outerWrapperId).click(function() {
                    jQuery('#'+objConfig.outerWrapperId).remove();
                    return false;
                });
                
                jQuery('#'+objConfig.wrapperId).click(function() {
                    return false;
                });
            }
            
            /** Success events - return the callback */
            jQuery('#'+objConfig.confirmTrigger).click(function() {
                /* Close the alert box */
                jQuery('#'+objConfig.cancelTrigger).trigger('click');
                return callback();
            });
            
            /* Ensure it returns false */
            return false;

        },
        
        parseTemplate: function( objConfig, timestamp ) {
            
            var template = objConfig.template;
            var objReplace = objMethods.getConfig;
            var replace;
            
            jQuery.each(objReplace, function(variable, search) {
                replace = objConfig[variable];
                if(replace === null || replace === undefined) { replace = ''; }
                
                template = template.replace(search, replace);
            });
            
            return template;
            
        }

    };
    
    
    /* Public methods */
    jQuery.jconfirm = function(options, callback) {
    
        /* Default values */
        var objConfig = jQuery.extend({
            cancel: 'Cancel', /* Cancel message - too afraid to carry on */
            cancelTrigger: 'jconfirmCancelTrigger', /* ID of cancel trigger */
            confirm: 'OK', /* Confirmation message - may be 'OK', 'Yes', or 'Fo shizzle' */
            confirmTrigger: 'jconfirmConfirmTrigger', /* ID of confirmation trigger */
            closeOnOuterWrapperClick: false, /* Run cancel event if click outside the box */
            maxWidth: 500, /* Max width of box */
            message: null, /* The message, if further explanation is needed */
            outerWrapperId: 'jconfirmOuter', /* ID of outer wrapper - for making a background colour */
            template: null, /* The template */
            title: 'Are you sure?', /* The question you are asking */
            wrapperId: 'jconfirmWrapper' /* ID of wrapper */
        }, options);
        
        /* What method are we running? */
        if( typeof options === 'function' ) {
            /* Use default options */
            callback = options;
        } else if ( options === 'getConfig' ) {
            /* Get the config options for the string replace */
            return objMethods.getConfig;
        } else if ( (typeof options === 'object' && typeof callback === 'function' ) === false ) {
            /* Error */
            jQuery.error( 'jConfirm incorrectly initialized.  Please check the documentation' );
        }
        
        return objMethods.init(objConfig, callback);

    };
})(jQuery);
