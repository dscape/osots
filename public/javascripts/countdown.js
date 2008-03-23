// countdown.js
// Alcides Fonseca
// http://alcidesfonseca.com


Number.prototype.ToFormatedTime = function() {
	// Small hack to make a pretty display of the time
	
	pretty = function(n) {
		if (n >= 10)
			return n;
		else
			return "0" + n;
	}
	
	d = new Date()
	d.setTime( this * 1000 );
	return pretty(d.getHours()-1) + ":" + pretty(d.getMinutes()) +":"+ pretty(d.getSeconds());
}



// Sample usage:
// new CountDown( 5 , "form_number_one", "div_id_where_time_goes")

var CountDown = Class.create(PeriodicalExecuter, {
  // redefine the speak method
  initialize: function($super, timeremaining, form_id, counter_id) {
	this.timeremaining = timeremaining;
	this.form = $(form_id);
	this.counter = $(counter_id);

	this.counter.innerHTML = this.timeremaining.ToFormatedTime();
	
    $super(function(pe) {
			this.timeremaining -= 1;
			this.counter.innerHTML = this.timeremaining.ToFormatedTime();
			if (this.timeremaining == 0) {
				pe.stop();
				this.form.submit();
			}
		},1);

  }
});