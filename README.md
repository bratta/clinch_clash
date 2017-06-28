# ClinchClash

Let your decision making battle itself out

## Installation and Usage

**NOTE:** You will need your own client id and client secret key from Yelp. Get
that from https://www.yelp.com/developers

**NOTE:** This is currently under active development and considered pre-pre-pre-alpha.

As such I haven't even released a gem yet. For now, clone the
repository, then type this to get it going:

    $ cp clinch-clash.yml.sample ~/.clinch-clash.yml  # Edit with your own Yelp keys
    $ bundle
    $ bin/clinch_clash

Once it is to a point where I consider it releasable, you will install
it as such: 

    $ gem install clinch_clash
    $ clinch_clash

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
