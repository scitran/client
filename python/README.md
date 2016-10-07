### quickstart
looks a bit crazy, but it works!
```bash
pip install -e git+git@github.com:scitran/client.git@cgc/dev_python#egg=scitran_client&subdirectory=python
```

Check out [this example](examples/fsl_bet.py) to see how to use it! you can run the example locally too
```bash
git clone git@github.com:scitran/client.git
cd client/python
virtualenv env
env/bin/pip install .
env/bin/python examples/fsl_bet.py
```

### contributing
want to run changes to this code locally? it's pretty easy to get it added to an existing env. the `--upgrade` flag
ensures that your changes will get picked up.
```
pip install --upgrade $WORKSPACE/client/python
```
