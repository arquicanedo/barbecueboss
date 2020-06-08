import xml.etree.ElementTree as ET
import glob
import sys



def get_supported_configurations():
    directories = glob.glob('./*')
    configurations = []
    for d in directories:
        if 'round' in d or 'rectangle' in d or 'semiround' in d:
            name = d.split('-')
            print(name)
            configurations.append(name[1]+'-'+name[2])
    return configurations


def extract_devices_per_family(f, configs):
    family_dict = {}
    root = ET.parse(f).getroot()
    for tag in root.findall('devices/device'):
        device_family = tag.get('family')
        device_name = tag.get('name');
        if device_family not in family_dict:
            family_dict[device_family] = []
        family_dict[device_family].append(device_name)

    for i in family_dict.keys():
        if i in configs:
            print('[Supported] ', i)
        else:
            print('[NOT SUPPORTED]', i)
        for j in family_dict[i]:
            print('\t', j)

if __name__ == '__main__':
    if len(sys.argv) <= 1:
        print('device_family.py /path/to/devices.xml');
    else: 
        configs = get_supported_configurations()
        extract_devices_per_family(sys.argv[1], configs)


