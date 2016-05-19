import os, logging

def getfiles(path):
    if os.path.isdir(path):
        return set(f for f in os.listdir(path) if not f[0] == '.')
    else:
        logging.error("invalid directory or path: %s" % path)
        return []

def getdirs(path):
    if os.path.isdir(path):
        return set(f for f in os.listdir(path) if (f[0] != '.') and os.path.isdir(os.path.join(path, f)))
    else:
        logging.error("invalid directory or path: %s" % path)
        return []

