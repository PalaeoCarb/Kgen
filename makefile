.PHONY: test-python, build-python, upload-python, distribute-python

test-python:
	cd python; python -m unittest

build-python:
	cd python; python setup.py sdist bdist_wheel

upload-python:
	cd python; twine upload dist/kgen-$$(python setup.py --version)*

distribute-python:
	make test-python
	make build-python
	make upload-python
