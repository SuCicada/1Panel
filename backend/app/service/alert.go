package service

import (
	"encoding/json"
	"fmt"
	"github.com/1Panel-dev/1Panel/backend/app/dto"
	"github.com/1Panel-dev/1Panel/backend/utils/xpack"
	"net/http"
	"strings"
)

type sAlert struct{}

var Alert = &sAlert{}

func (s *sAlert) PushAlert(pushAlert dto.PushAlert) error {
	setting, err := NewISettingService().GetSettingInfo()
	if err != nil {
		return err
	}

	title := fmt.Sprintf("⚠️Task: %s", pushAlert.TaskName)
	body := fmt.Sprintf("Type: %s\nName: %s\nStatus: Failed",
		pushAlert.AlertType,
		pushAlert.TaskName)
	client := &http.Client{Transport: xpack.LoadRequestTransport()}

	data := map[string]string{
		"title": title,
		"body":  body,
	}

	jsonData, _ := json.Marshal(data)
	url := setting.AlertUrl
	//url := "sss"
	req, err := http.NewRequest("POST", url, strings.NewReader(string(jsonData)))
	if err != nil {
		return err
	}
	req.Header.Set("Content-Type", "application/json")
	resp, err := client.Do(req)
	if err != nil {
		return err
	}
	defer resp.Body.Close()

	return nil
}
