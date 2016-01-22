var com = com || {};
com.nature = com.nature || {};

(function ($) {
	com.nature.Configuration = {
		_data: {},

		//Add only, prevents accidental overwriting unless explicitly using change()
		add: function (data) {
			var that = this;
			jQuery.each(data, function (k, v) {
				if (!that._data[k] && v !== "") {
					that._data[k] = v;
				}
			});
		},
		//Update a declared config setting, assume add if it's not set for some reason
		change: function (data) {
			var that = this;
			jQuery.each(data, function (k, v) {
				that._data[k] = v;
			});
		},
		//Remove a stored setting if you ever need to
		remove: function (name) {
			if (this._data[name]) {
				delete this._data[name];
			}
		},
		get: function (name) {
			return this._data[name] || false;
		}
	};
}(jQuery));

(function ($) {
	com.nature.PageManager = {
		_cookie: com.nature.Cookie,
		_path: document.location.href.replace(/^https?:\/\/[^\/]+/i, ''),

		// Attempt to track links with data bindings
		trackDataBinding: function (ev, element) {
			var $el = element;
			var _data = {};

			if ($el.data()) {
				var i;
				for (i in $el.data()) {
					if (i !== 'webtrack') {
						_data[i] = $el.data(i).toString() || null;
					}
				}
			}
			// some defaults
			if (!_data.action || _data.action === "") {
				_data.action = "click";
			}
			if (!_data.destination || _data.destination === "") {
				_data.destination = $el.attr('href');
			}
			if (!_data.source || _data.source === "") {
				_data.source = window.location.href;
			}
			if (_data) {
				this.track(_data);
			}
		},
		trackClick: function (data) {
			this.track(data);
		},
		track: function (params) {
			var wt = window._tag || window.dcs;
			var args = [];
			if (com.nature.Configuration.get('webtrendsEnabled') === 'true' && wt) {
				// WT requires all of our custom params to be set
				var required = ['action', 'source', 'destination', 'type', 'direction'];
				var n = required.length;
				while (n--) {
					if (!(required[n] in params)) {
						params[required[n]] = '';
					}
				}
				//Default settings for JS tags, if not already specified
				if (!params['dl']) { params['dl'] = '51'; }
				if (!params['ndl']) { params['ndl'] = '51'; }
				var args = [];
				for (var prop in params) {
					if (params.hasOwnProperty(prop)) {
						args.push('WT.' + prop);
						args.push(params[prop]);
					}
				}
				wt.dcsMultiTrack.apply(wt, args);
			}
		},
		toString: function () {
			return '[object com.nature.PageManager]';
		}
	};
}(jQuery));

(function ($) {
	$(function () {
		this.PageManager = com.nature.PageManager;
		var pm = this.PageManager;
		$('body a[data-webtrack="true"]').click(function (ev) {
			var el = $(this);
			com.nature.Configuration.add({'webtrendsEnabled': 'true'}); // turn on the 'Trends
			pm.trackDataBinding(ev, el);
		});
	});
}(jQuery));
